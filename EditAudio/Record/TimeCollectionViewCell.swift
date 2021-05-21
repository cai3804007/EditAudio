//
//  TimeCollectionViewCell.swift
//  EditAudio
//
//  Created by yoyochecknow on 2021/5/20.
//

import UIKit

class TimeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func draw(time: String) {
        timeLabel.text = time
    }

}
