//
//  WaveViewController.swift
//  EditAudio
//
//  Created by yoyochecknow on 2021/5/19.
//

import UIKit
import AudioKit

struct RecorderData {
    var isRecording = false
    var isPlaying = false
}
class RecorderConductor {
    let engine = AudioEngine()
    var recorder: NodeRecorder?
    let player = AudioPlayer()
    var silencer: Fader?
    let mixer = Mixer()

     var data = RecorderData() {
        didSet {
            if data.isRecording {
                NodeRecorder.removeTempFiles()
                do {
                    try recorder?.record()
                } catch let err {
                    print(err)
                }
            } else {
                recorder?.stop()
            }

            if data.isPlaying {
                if let file = recorder?.audioFile {
                    player.file = file
                    player.play()
                }
            } else {
                player.stop()
            }
        }
    }

    init() {
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
    }

    func start() {
        do {
            try engine.start()
        } catch let err {
            print(err)
        }
    }

    func stop() {
        engine.stop()
    }
}

//import AudioKitUI
class WaveViewController: UIViewController {
    @IBOutlet weak var waveCotentView: UIView!
    
    @IBOutlet weak var playContentView: UIView!
   
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var playLabel: UILabel!
    var recoderTime = 0.0
    var playTime = 0.0
    

    
    lazy var timer=Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(timechange), userInfo: nil, repeats: true)
     
     lazy var playTimer=Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(playchange), userInfo: nil, repeats: true)
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
      
    }
    
    @objc func timechange() {
        recoderTime = recoderTime + 0.1
        let str = NSString(format:"%.2f",recoderTime)
        self.recordLabel.text = "录制时长:\(str)s"
    }

    @objc func playchange() {
        
        playTime = playTime + 0.1
        let str = NSString(format:"%.2f",playTime)
        self.recordLabel.text = "播放时长:\(str)s"
    }
    
    @IBAction func beginWrite(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {//正在录制
            timer.fireDate = NSDate.distantPast
            
        }else{
            timer.fireDate = NSDate.distantFuture
            
        }
    }
    @IBAction func beginPlay(_ sender: UIButton) {
       
        
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
