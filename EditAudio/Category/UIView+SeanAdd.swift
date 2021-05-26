//
//  UIView+SeanAdd.swift
//  SwiftFrame
//
//  Created by yoyochecknow on 2020/7/17.
//  Copyright © 2020 SeanOrganization. All rights reserved.
//

import UIKit


public extension UIView {
     var sean_x : CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            var f = self.frame
            f.origin.x = newValue
            self.frame = f
        }
    }
    /// y
     var sean_y : CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            var f = self.frame
            f.origin.y = newValue
            self.frame = f
        }
    }
    /// width
     var sean_width : CGFloat {
        get {
            return self.frame.size.width
        }
        set {
            var f = self.frame
            f.size.width = newValue
            self.frame = f
        }
    }
    /// height
     var sean_height : CGFloat {
        get {
            return self.frame.size.height
        }
        set {
            var f = self.frame
            f.size.height = newValue
            self.frame = f
        }
    }
    /// origin
     var sean_origin : CGPoint {
        get {
            return self.frame.origin
        }
        set {
            var f = self.frame
            f.origin = newValue
            self.frame = f
        }
    }
    /// size
     var sean_size : CGSize {
        get {
            return self.frame.size
        }
        set {
            var f = self.frame
            f.size = newValue
            self.frame = f
        }
    }
    /// centerX
     var sean_centerX : CGFloat {
        get {
            return self.center.x
        }
        set {
            var c = self.center
            c.x = newValue
            self.center = c
        }
    }
    /// centerY
     var sean_centerY : CGFloat {
        get {
            return self.center.y
        }
        set {
            var c = self.center
            c.y = newValue
            self.center = c
        }
    }
    /// maxY
     var sean_maxY : CGFloat {
        get {
            return self.frame.origin.y + self.frame.size.height;
        }
    }
    
    /// maxX
       var sean_maxX : CGFloat {
          get {
              return self.frame.origin.x + self.frame.size.width
          }
      }
    
    //在协议里面不允许定义class 只能定义static
       static func loadFromNib(_ nibname: String? = nil) -> Self {//Self (大写) 当前类对象
           //self(小写) 当前对象
           let loadName = nibname == nil ? "\(self)" : nibname!
           
             return Bundle.main.loadNibNamed(loadName, owner: nil, options: nil)?.first as! Self
       }
    
    
    func addTapGesturesTarget(_ target: Any?, selector: Selector) {
        isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: target, action: selector)
        tapGesture.numberOfTapsRequired = 1
        addGestureRecognizer(tapGesture)
    }
    
    func addPanGesturesTarget(_ target: Any?, selector: Selector) {
        isUserInteractionEnabled = true
//        let tapGesture = UITapGestureRecognizer(target: target, action: selector)
        let panGesture = UIPanGestureRecognizer(target: target, action: selector)
        addGestureRecognizer(panGesture)
    }
    
    
    func addRoundedCorners(_ corners: UIRectCorner,withRadii radii: CGSize,viewRect rect: CGRect
    ) {
        // 单边圆角或者单边框
        let maskPath = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: radii)
        let maskLayer = CAShapeLayer()
        maskLayer.frame = rect
        maskLayer.path = maskPath.cgPath
        layer.mask = maskLayer
    }
    
}





