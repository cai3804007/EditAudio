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
        RecorderFileHandler().removeFile(fileName: "yinpin.m4a")
        
    }
    
    
    
    
}

