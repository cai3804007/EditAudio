//
//  WaveViewController.swift
//  EditAudio
//
//  Created by yoyochecknow on 2021/5/19.
//

import UIKit
import AudioKit
import AVFoundation
class WaveViewController: UIViewController {

    let engine = AudioEngine()
    var recorder: NodeRecorder?
    let player = AudioPlayer()
    var silencer: Fader?
    let mixer = Mixer()
    
    /// 声音数据数组
    private var soundMeters: [Float] = []
    let collectionViewHeight : CGFloat = 150.0
    var screenHalfWidth: CGFloat {
        UIScreen.main.bounds.width / 2
    }
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var collectionview: UICollectionView!{
        didSet {
            collectionview.tag = CollectionType.time.rawValue
            collectionview.dataSource = self
            collectionview.delegate = self
            collectionview.showsHorizontalScrollIndicator = false
            collectionview.isScrollEnabled = false
            collectionview.registerForNib(WaveViewCell.self)
        }
    }
    //录音数组
    var audios = [URL]()
    
    
    var fileTable: Table?
    var number : CGFloat = 0.0
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var recorderContentView: UIView!
    
    
    
    var tappableNode: Fader!
    var tracker: PitchTap!

    override func viewDidLoad() {
        super.viewDidLoad()
//        NodeRecorder.removeTempFiles()
        self.configAudio()
        guard let input = engine.input else {
            fatalError()
        }
        do {
            tappableNode = Fader(input)
            recorder = try NodeRecorder(node: tappableNode)
        } catch let err {
            fatalError("\(err)")
        }
        
        
        let silencer = Fader(tappableNode, gain: 0)
        
        self.silencer = silencer
        mixer.addInput(silencer)
        mixer.addInput(player)
        engine.output = mixer

        tracker = PitchTap(input) { pitch, amp in
            DispatchQueue.main.async {
                if self.recorder?.isRecording == true{
                    self.number += 1
//                    let time = Date.init().timeIntervalSince1970
//                    print("number====== : \(self.number)    time ==== \(time)")
                    self.update(pitch[0], amp[0])
                }
            }
        }
        
        
        do {
            try engine.start()
            tracker.start()
        } catch let err {
            print(err)
        }
    
      

    }
    @IBAction func redTable(_ sender: Any) {
        self.configTable()
    }
    
    func configAudio()  {
        do {
            Settings.bufferLength = .short
            try AVAudioSession.sharedInstance().setPreferredIOBufferDuration(Settings.bufferLength.duration)
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord,
                                                            with: [.defaultToSpeaker, .mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let err {
            print(err)
        }
    }
    
    
    
    func configTable()  {
        guard let url = SeanFileManager.getAudios()?.first, let fileURL = SeanFileManager.fileUrl(fileName: url, .audio) else { return  }
        let file = try! AVAudioFile(forReading:fileURL)
        guard let fileTable = Table(file: file) else { return }
        
        let tabeView = TableView.init(fileTable, frame: CGRect(width: 375, height: 150))
        
        contentView.addSubview(tabeView)
        
    }
    
    func update(_ pitch: AUValue, _ amp: AUValue) {
//        data.pitch = pitch
//        data.amplitude = amp
        self.soundMeters.append(amp)
        self.insertCollectionView()
    }
    
    
    //开始录音
    @IBAction func beginWrite(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        // self.conductor.start()
        if sender.isSelected {
            do { try self.recorder?.record()
                print("开始录音")
                
            }
            catch let err{
                print(err)
            }
        }else{
            self.pauseRecord()
        }
      
       
    }
    
    
    @IBAction func startEdug(_ sender: UIButton) {
       
    }
    
    
    func changeFileExt() {
        var options = FormatConverter.Options()
        // any options left nil will assume the value of the input file
        options.format = "wav"
        options.sampleRate = 48000
        options.bitDepth = 24
        let oldURL = URL(fileURLWithPath: "123")
        let newURL = URL(fileURLWithPath: "456")
        let converter = FormatConverter(inputURL: oldURL, outputURL: newURL, options: options)
        converter.start { error in
           
        };
        
    }
    
    
    //开始播放
    @IBAction func beginPlay(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            self.stopRecord()
            player.stop()
            if let file = self.recorder?.audioFile{
                let url = self.recorder?.audioFile?.url
                player.reset()
                player.file = file
                print("url=====\(String(describing: url))")
                  player.volume = 1.0
                  player.play()
                  print("开始播放")
            }
        }else{
            player.stop()
        }
    }
    
    
    func startRecord() {
       
    }
     
    func pauseRecord() {
        if let url = self.recorder?.audioFile?.url {
            self.audios.append(url)
        }
        self.recorder?.stop()
        
    }
    
    func stopRecord() {
 
        if let isRecording = self.recorder?.isRecording {
            if isRecording {
                self.recorder?.stop()
                print("停止录音")
            }
        }
    }
    
    deinit {
        engine.stop()
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
            self.collectionview.performBatchUpdates(
                { self.collectionview.insertItems(at: [lastIndexPath]) },
                completion: { _ in
                    //insert完成后滚动
                    self.collectionview.scrollToItem(
                        at: lastIndexPath, at: .left, animated: false
                    )
                }
            )
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}



extension WaveViewController: UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 取得波形数量
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

extension WaveViewController: UICollectionViewDelegateFlowLayout {
    
    
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

