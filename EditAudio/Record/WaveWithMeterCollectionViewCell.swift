//
//  WaveWithMeterCollectionViewCell.swift
//  EditAudio
//
//  Created by yoyochecknow on 2021/5/20.
//

import UIKit

class WaveWithMeterCollectionViewCell: UICollectionViewCell {

    @IBOutlet var waveHeight: NSLayoutConstraint!
    @IBOutlet var waveView: UIView!
    @IBOutlet weak var meterHeight: NSLayoutConstraint!
    @IBOutlet weak var meterView: UIView!
    
    func draw(height: CGFloat, index: Int) {
        waveHeight.constant = height
        waveView.isHidden = index % 2 != 0
        //仪表显示
        meterView.isHidden = index % 2 != 0
        // 每5秒改变一次高度
        meterHeight.constant = index % 50 == 0 ? 10 : 5
        // 每隔一秒改变颜色
        meterView.backgroundColor = index % 10 == 0 ? .lightGray : .black
    }

}
