//
//  ViewController.swift
//  EditAudio
//
//  Created by yoyochecknow on 2021/5/18.
//

import UIKit

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func deleClick(_ sender: Any) {
        SeanFileManager.removeFile(fileName: "yinpin.m4a")
        
    }
    
    
    @IBAction func editClick(_ sender: Any) {
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
    
    
}

