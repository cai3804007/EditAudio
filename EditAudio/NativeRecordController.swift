//
//  NativeRecordController.swift
//  EditAudio
//
//  Created by yoyochecknow on 2021/5/19.
//

import UIKit
import AVFoundation

class NativeRecordController: UIViewController, AVAudioRecorderDelegate {
    enum CollectionType: Int, CaseIterable {
        case decibel
        case time
    }
    var collectionTypes: [CollectionType] = CollectionType.allCases
    
    
    @IBOutlet weak var timeCollectionView: UICollectionView!{
        didSet {
            timeCollectionView.tag = CollectionType.time.rawValue
            timeCollectionView.dataSource = self
            timeCollectionView.delegate = self
            timeCollectionView.showsHorizontalScrollIndicator = false
            timeCollectionView.isScrollEnabled = false
//            timeCollectionView.registerNib(cellType: TimeCollectionViewCell.self)
            timeCollectionView.registerForNib(TimeCollectionViewCell.self)
        }
    }
    
    
    @IBOutlet weak var waveCotentView: UIView!
    
    @IBOutlet weak var playContentView: UIView!
   
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var playLabel: UILabel!
    var recoderTime = 0.0
    var playTime = 0.0
    
    let collectionViewHeight : CGFloat = 150.0
    var screenHalfWidth: CGFloat {
        UIScreen.main.bounds.width / 2
    }
    @IBOutlet weak var recordCollectionView: UICollectionView!
    
    @IBOutlet weak var playCollectionView: UICollectionView!
    
   lazy var timer=Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(timechange), userInfo: nil, repeats: true)
    
    lazy var playTimer=Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(playchange), userInfo: nil, repeats: true)
    
    var soundFileURL : URL?
    var fileHandler = SeanFileManager()
    /// 录音器
       private var recorder: AVAudioRecorder!
       /// 录音器设置
       private let recorderSetting = [AVSampleRateKey : NSNumber(value: Float(44100.0)),//声音采样率
                                        AVFormatIDKey : NSNumber(value: Int32(kAudioFormatMPEG4AAC)),//编码格式
                                AVNumberOfChannelsKey : NSNumber(value: 1),//采集音轨
                             AVEncoderAudioQualityKey : NSNumber(value: Int32(AVAudioQuality.medium.rawValue))]//声音质量
       /// 录音计时器
//       private var timer: Timer?
       /// 波形更新间隔
       private let updateFequency = 0.05
       /// 声音数据数组
    private var soundMeters: [Float] = []
    
    lazy var player = SeanAudioPlayer()
       /// 录音时间
       private var recordTime = 0.00
    

    override func viewDidLoad() {
        super.viewDidLoad()
//        fileHandler.removeFile(fileName: "yinpin.m4a")
//        soundFileURL = fileHandler.fileUrl(fileName: "yinpin.m4a")
        
        let audioFileName = SeanFileManager.audioName()
        
        soundFileURL = SeanFileManager.fileUrl(fileName: audioFileName, .audio)
        
        
        self.recordCollectionView.delegate = self
        self.recordCollectionView.dataSource = self
        self.recordCollectionView.registerForNib(WaveViewCell.self)
        configRecord()
        configAVAudioSession()
        self.recordCollectionView.reloadData()
    }
    
    @objc func timechange() {
        recoderTime = recoderTime + 0.1
        let str = NSString(format:"%.2f",recoderTime)
        self.recordLabel.text = "录制时长:\(str)s"
        
        if self.recorder.isRecording {
            self.updateMeters()
            self.insertCollectionView() //获取的波形的显示
        }
    }

    @objc func playchange() {
        playTime = playTime + 0.1
        let str = NSString(format:"%.2f",playTime)
        self.recordLabel.text = "播放时长:\(str)s"
    }
    
    @IBAction func beginWrite(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            self.continueRecord()
        }else{
            self.pauseRecord()
        }
        
    }
    @IBAction func beginPlay(_ sender: UIButton) {
        if self.recorder.isRecording {
            self.stopRecord()
        }
        player.setupPlayer(with: soundFileURL!)
        player.play(currentTime: 0)
    }
    
    @IBAction func editClick(_ sender: Any) {
        self.stopRecord()
        
        
        
        let story = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = story.instantiateViewController(withIdentifier: "EditAutio")

        if let audioEditorViewController = vc as? EditRecorderViewController{
            audioEditorViewController.editorManager = AudioEditorManager(
                amplitudes: self.soundMeters,
                originalUrl:self.soundFileURL!
            )
            navigationController?.pushViewController(
                audioEditorViewController,
                animated: true
            )
        }       
    }
    
    
    func stopRecord() {
        self.recorder.stop()
        timer.fireDate = NSDate.distantFuture
    }
    
    func pauseRecord() {
        timer.fireDate = NSDate.distantFuture
        self.recorder.pause()
    }
    
    func continueRecord() {
        timer.fireDate = NSDate.distantPast
        self.recorder.record()
    }
    
    
    

    //更新collectionview
    private func insertCollectionView() {
        if self.soundMeters.isEmpty {
            return
        }
        // 获取的波形的IndexPath
        let endIndex = self.soundMeters.count - 1
        let lastIndexPath = IndexPath(row: endIndex, section: 0)
        UIView.performWithoutAnimation { //动画OFF
            // 获取的波形insert到CollectionView
            self.recordCollectionView.performBatchUpdates(
                { self.recordCollectionView.insertItems(at: [lastIndexPath]) },
                completion: { _ in
                    //insert完成后滚动
                    self.recordCollectionView.scrollToItem(
                        at: lastIndexPath, at: .left, animated: false
                    )
                }
            )
        }
    }
    
    
    //配置相关
    private func configAVAudioSession() {
          let session = AVAudioSession.sharedInstance()
          do { try session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker) }
          catch { print("session config failed") }
      }
      
      
      private func configRecord() {
          AVAudioSession.sharedInstance().requestRecordPermission { (allowed) in
              if !allowed {
                  return
              }
          }
          let session = AVAudioSession.sharedInstance()
          do { try session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker) }
          catch { print("session config failed") }
          do {
              self.recorder = try AVAudioRecorder(url: self.directoryURL()!, settings: self.recorderSetting)
              self.recorder.delegate = self
              self.recorder.prepareToRecord()
              self.recorder.isMeteringEnabled = true
          } catch {
              print(error.localizedDescription)
          }
          do { try AVAudioSession.sharedInstance().setActive(true) }
          catch { print("session active failed") }
      }
      
      
      private func directoryURL() -> URL? {
          // do something ...
          return soundFileURL
      }
    
    
    //添加音频数据
    private func updateMeters() {
         recorder.updateMeters()
         recordTime += updateFequency
         addSoundMeter(item: recorder.averagePower(forChannel: 0))
     }
     
    func amplitude() -> Float {
        self.recorder?.updateMeters()
        // 以分贝为单位返回指定信道的平均功率
        // averagePower 0db:最大功率- 160db:最小功率(几乎无声)
        let decibel = recorder?.averagePower(forChannel: 0) ?? 0
        // 从分贝获得振幅
        let amp = pow(10, decibel / 20)
        return max(0, min(amp, 1)) // 0…1之间的值
    }
    
     
     private func addSoundMeter(item: Float) {
        // 从分贝获得振幅
        let amp = pow(10, item / 20)
        soundMeters.append(max(0, min(amp, 1)))
     }
    

}

extension NativeRecordController: UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 取得した波形の数
       return self.soundMeters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(with: WaveViewCell.self, for: indexPath)
        let amplitudes = self.soundMeters[indexPath.row]
        // 振幅(0..1) * collectionView的高度=波形高度
        let waveHeight = CGFloat(amplitudes) * collectionViewHeight
        cell.draw(height: waveHeight, index: indexPath.row)
        return cell
    }
    
}

extension NativeRecordController: UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      
        let meterWidth: CGFloat = 2
        return CGSize(width: meterWidth, height: collectionViewHeight)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        .zero
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: screenHalfWidth, height: collectionViewHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        CGSize(width: screenHalfWidth, height: collectionViewHeight)
    }
}

extension NativeRecordController{
    
    
    
    
    
    
}



