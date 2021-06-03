//
//  ViewController.swift
//  EditAudio
//
//  Created by yoyochecknow on 2021/5/18.
//

import UIKit
import AVFoundation

class ViewController: UITableViewController {
    let par = ParsingAudioHander.init()
//    let aaa = ExtAudioFileMixer.init()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func syntheticAudioButtonClick(_ sender: Any) {
        let name = SeanFileManager.audioName()
        guard let path = SeanFileManager.fileUrl(fileName: name) else {
            return
        }
        
        
        
        
        let audio = SeanFileManager.getBundlePath(name: "歌曲", type: "mp3")
        let bg = SeanFileManager.getBundlePath(name: "背景", type: "mp3")
        
//        par.mixAudio(audio, andAudio: bg, toFile: path.path, preferedSampleRate: 1.0)
        
        par.synthetiAudio(withAudioPath: audio, bgPath: bg, outPath: path.path, completion: nil)
        
    }
    
    
    @IBAction func editClick(_ sender: Any) {
        guard let url = SeanFileManager.getAudios()?.first else {
            return
        }
        guard let string = SeanFileManager.fileUrl(fileName: url, .audio)?.path else { return  }
        self.getAudioMaters(audio: URL(fileURLWithPath: string))
        
        
//        let editURL = SeanFileManager().fileUrl(fileName: "wode.m4a")
//        let story = UIStoryboard.init(name: "Main", bundle: nil)
//        let vc = story.instantiateViewController(withIdentifier: "EditAutio")
//        if let audioEditorViewController = vc as? EditRecorderViewController{
//
//            audioEditorViewController.editorManager = AudioEditorManager(
//                amplitudes: self.soundMeters,
//                originalUrl:editURL!
//            )
//            navigationController?.pushViewController(
//                audioEditorViewController,
//                animated: true
//            )
        
    }
    
    func getAudioMaters(audio:URL) {
        
       
        
        let array = par.getRecorderData(from: audio)
        var amplitudes = [Float]()
        for obj in array {
            amplitudes.append(obj.floatValue)
        }
        let story = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = story.instantiateViewController(withIdentifier: "EditAutio")
        if let audioEditorViewController = vc as? EditRecorderViewController{
            audioEditorViewController.editorManager = AudioEditorManager(
                amplitudes: amplitudes,
                originalUrl:audio
            )
            self.navigationController?.pushViewController(
                audioEditorViewController,
                animated: true
            )
        }
        
//        let datas : NSData = (NSData)(data: par.getRecorderData(from: audio))
//        let count = datas.count/2
//        let byte = datas.bytes
//        guard let max : UInt8 = datas.max() else {
//            return
//        }
//        let min = datas.min()
//        var samples = [Float]()
//        for i in 0 ..< count {
//            let aaa = datas[i]
//            let f : Float = Float(aaa/max)
//
//
//        }
//
//
//
//        return
        
        
        
        //        AVURLAsset*audioAsset = [AVURLAsset URLAssetWithURL:audio options:nil];`
//        let audioAsset = AVURLAsset(url: audio, options: [AVURLAssetPreferPreciseDurationAndTimingKey: true])
//        let time = audioAsset.duration
//        let audioDurationSeconds = CMTimeGetSeconds(time)
//        let count = audioDurationSeconds/0.1
//
//        // get access to the raw, normalized amplitude samples
//        let waveformAnalyzer = WaveformAnalyzer(audioAssetURL: audio)
//
//        waveformAnalyzer?.samples(count: Int(count)) { samples in
//            //            print("sampled down to 10, results are \(samples ?? [])")
//                DispatchQueue.main.async {
//                    let story = UIStoryboard.init(name: "Main", bundle: nil)
//                    let vc = story.instantiateViewController(withIdentifier: "EditAutio")
//                    if let audioEditorViewController = vc as? EditRecorderViewController{
//                        audioEditorViewController.editorManager = AudioEditorManager(
//                            amplitudes: samples ?? [0],
//                            originalUrl:audio
//                        )
//                    self.navigationController?.pushViewController(
//                        audioEditorViewController,
//                        animated: true
//                    )
//                }
//            }
//        }
//    }
    
    }
    
    
}

