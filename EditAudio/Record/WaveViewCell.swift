//
//  WaveViewCell.swift
//  EditAudio
//
//  Created by yoyochecknow on 2021/5/20.
//

import UIKit

class WaveViewCell: UICollectionViewCell {
    @IBOutlet weak var waveHeight: NSLayoutConstraint!
    @IBOutlet weak var waveView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func draw(height: CGFloat, index: Int) {
        // 振幅的高度
        waveHeight.constant = height
        // 显示偶数波形以获取单元之间的空间。
        waveView.isHidden = index % 2 != 0
    }

}
