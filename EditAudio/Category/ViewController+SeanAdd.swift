//
//  ViewController+SeanAdd.swift
//  SwiftFrame
//
//  Created by yoyochecknow on 2020/8/27.
//  Copyright © 2020 SeanOrganization. All rights reserved.
//

import UIKit

public extension UIViewController {
    
    //  Converted to Swift 5.3 by Swiftify v5.3.22312 - https://swiftify.com/
    
    @discardableResult
    func addNavLeftBtn(withName name: String?, image: String?) -> UIButton? {
        var name = name
        if name == nil {
            name = ""
        }

        guard let btn = creatBtn(withName: name, image: image) else {
            return nil
        }
       
        let array = configNavigationBarItems([btn], type: 0)
        navigationItem.leftBarButtonItems = array
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
        return btn
    }
    
    func configTitle(_ title: String?) {
        self.title = title
        addNavLeftBtn(withName: nil, image: "icon_return")
    }

    func creatBtn(withName name: String?, image: String?) -> UIButton? {
        var name = name
        if name == nil {
            name = ""
        }
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        if (image?.count ?? 0) > 0 {
            btn.setImage(UIImage(named: image ?? ""), for: .normal)
        }
        btn.setTitle(name, for: .normal)
        return btn
    }
    
    
    //0未左边按钮 1为右边按钮
    func configNavigationBarItems(_ buttons: [UIButton]?, type: Int) -> [UIBarButtonItem]? {
        var barItems: [UIBarButtonItem]? = []
        for i in 0..<(buttons?.count ?? 0) {
            let left = buttons?[i]
            if type == 0 {
                left?.addTarget(self, action: #selector(leftNavButtonClick(_:)), for: .touchUpInside)
            } else {
                left?.addTarget(self, action: #selector(rightNavButtonClick(_:)), for: .touchUpInside)
            }
            var leftItem: UIBarButtonItem? = nil
            if let left = left {
                leftItem = UIBarButtonItem(customView: left)
            }
            left?.tag = i
            if let leftItem = leftItem {
                barItems?.append(leftItem)
            }
        }
        return barItems
    }
         
    
    @objc func rightNavButtonClick(_ btn: UIButton?) {
    }

    @objc func leftNavButtonClick(_ btn: UIButton?) {
        navigationController?.popViewController(animated: true)
    }
    
    
    func getCurrentController() -> UIViewController? {
        guard let window = UIApplication.shared.windows.first else {
            return nil
        }
        var tempView: UIView?
        for subview in window.subviews.reversed() {
            if subview.classForCoder.description() == "UILayoutContainerView" {
                tempView = subview
                break
            }
        }
        
        if tempView == nil {
            tempView = window.subviews.last
        }
        
        var nextResponder = tempView?.next
        var next: Bool {
            return !(nextResponder is UIViewController) || nextResponder is UINavigationController || nextResponder is UITabBarController
        }

        while next{
            tempView = tempView?.subviews.first
            if tempView == nil {
                return nil
            }
            nextResponder = tempView!.next
        }
        return nextResponder as? UIViewController
    }
    
    
    
    
    
}

