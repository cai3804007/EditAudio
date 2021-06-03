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
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    //录音数组
    var audios = [URL]()
    
    
    var fileTable: Table?
    var tracker: PitchTap!
    var number : CGFloat = 0.0
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var recorderContentView: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
//        NodeRecorder.removeTempFiles()
        self.configAudio()
        guard let input = engine.input else {
            fatalError()
        }
        do {
            recorder = try NodeRecorder(node: input)
        } catch let err {
            fatalError("\(err)")
        }
        let silencer = Fader(input, gain: 0)
        self.silencer = silencer
        mixer.addInput(silencer)
        mixer.addInput(player)
        engine.output = mixer
        do {
            try engine.start()
        } catch let err {
            print(err)
        }
    
        
       
        tracker = PitchTap(input) { pitch, amp in
            DispatchQueue.main.async {
                //self.update(pitch[0], amp[0])
                self.number += 1
                
                print("number====== :\(self.number)")
            }
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
    
    
    //开始播放
    @IBAction func beginPlay(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            self.stopRecord()
            
            if let file = self.recorder?.audioFile{
                let url = self.recorder?.audioFile?.url
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
