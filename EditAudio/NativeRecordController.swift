//
//  NativeRecordController.swift
//  EditAudio
//
//  Created by yoyochecknow on 2021/5/19.
//

import UIKit

class NativeRecordController: UIViewController {
    @IBOutlet weak var waveCotentView: UIView!
    
    @IBOutlet weak var playContentView: UIView!
   
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var playLabel: UILabel!
    var recoderTime = 0.0
    var playTime = 0.0
    
    @IBOutlet weak var recordCollectionView: UICollectionView!
    
    @IBOutlet weak var playCollectionView: UICollectionView!
    
   lazy var timer=Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(timechange), userInfo: nil, repeats: true)
    
    lazy var playTimer=Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(playchange), userInfo: nil, repeats: true)
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        
        
    }
    
    @objc func timechange() {
        recoderTime = recoderTime + 0.1
        self.recordLabel.text = "录制时长:\(recoderTime)s"
    }

    @objc func playchange() {
        
        playTime = playTime + 0.1
        self.recordLabel.text = "播放时长:\(playTime)s"
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
