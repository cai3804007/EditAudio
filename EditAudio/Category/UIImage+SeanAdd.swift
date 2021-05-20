//
//  UIImage+SeanAdd.swift
//  MagFxBx
//
//  Created by yoyochecknow on 2021/4/8.
//  Copyright © 2021 MacBook. All rights reserved.
//

import Foundation
extension UIImage {
    class func courseDefault() -> UIImage! {
        return UIImage(named: "course_img_placeholder")
    }

    ///****正方形默认图******
    class func squareDefault() -> UIImage! {
        return UIImage(named: "course_img_placeholder")
    }

    ///****长方形默认图******
    class func rectangleDefault() -> UIImage! {
        return UIImage(named: "rectangle_placeholder")
    }

    ///****纵向长方形默认图******
    class func verRectangleDefaule() -> UIImage! {
        return UIImage(named: "ver_rectangle_placeholder")
    }

    ///****用户默认图******
    class func userDefault() -> UIImage! {
        return UIImage(named: "iconHead")
    }
}


extension UIImageView{
    func sd_setImage(url:String,_ placeholderImage : UIImage = UIImage.courseDefault()){
        
        guard let imageURL = URL(string: url) else { return  }
        self.sd_setImage(with: imageURL, placeholderImage: placeholderImage)
    }    
}

