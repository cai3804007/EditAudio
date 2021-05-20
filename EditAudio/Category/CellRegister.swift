//
//  CellRegister.swift
//  MagFxBx
//
//  Created by yoyochecknow on 2021/4/6.
//  Copyright © 2021 MacBook. All rights reserved.
//

import UIKit
// 给 UITableView 进行方法扩展，增加使用类型进行注册和复用的方法
extension UITableView {
    func register(_ cellClass: UITableViewCell.Type) {
           let identifier = String(describing: cellClass)
           register(cellClass, forCellReuseIdentifier: identifier)
       }
    func dequeueReusableCell<T: UITableViewCell>(with cellClass: T.Type, for indexPath: IndexPath) -> T {
        let identifier = String(describing: cellClass)
        return dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! T
    }
}
 
extension UICollectionView {
    
    func registerCell(_ cellClass: UICollectionViewCell.Type) {
           let identifier = String(describing: cellClass)
         register(cellClass, forCellWithReuseIdentifier: identifier)
       }
    
    func registerForNib(_ cellClass: UICollectionViewCell.Type) {
        let identifier = String(describing: cellClass)
        register(UINib.init(nibName: identifier, bundle: nil), forCellWithReuseIdentifier: identifier)
    }
    
    func registerHeaderForNib(_ cellClass: UICollectionReusableView.Type) {
        let identifier = String(describing: cellClass)
        register(UINib.init(nibName: identifier, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: identifier)
    }
    
    func registerFooterForNib(_ cellClass: UICollectionReusableView.Type) {
        let identifier = String(describing: cellClass)
        register(UINib.init(nibName: identifier, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: identifier)
    }
    
    
    
    func dequeueReusableCell<T: UICollectionViewCell>(with cellClass: T.Type, for indexPath: IndexPath) -> T {
        let identifier = String(describing: cellClass)
        return dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! T
    }
    
    
    func dequeueReusableViewHeader<T: UICollectionReusableView>(with identifier: String, for indexPath: IndexPath) -> T {
        let header = dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: identifier, for: indexPath)
        return header as! T
    }
    
    
    func dequeueReusableViewHeader<T: UICollectionReusableView>(with cellClass: T.Type, for indexPath: IndexPath) -> UICollectionReusableView {
        let identifier = String(describing: cellClass)
        print("iiiiii    " + identifier)
        let header = dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: identifier, for: indexPath)
        print("ooooooo    " + identifier)
        return header //as! T
    }
    
    
    func dequeueReusableViewFooter<T: UICollectionReusableView>(with cellClass: T.Type, for indexPath: IndexPath) -> T {
        let identifier = String(describing: cellClass)
        return dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: identifier, for: indexPath) as! T
    }
    
}

////协议，使用关联类型
//protocol TableViewCell {
//    associatedtype T
//    func setUI(_ model: T)
//}
////协议，使用关联类型
//protocol UICollectionViewCell {
//    associatedtype T
//    func setUI(_ model: T)
//}
//
//
//extension UITableViewCell{
//    func setUI(model: Element) {
//
//    }
//}
//
//extension UICollectionViewCell{
//
//    func setUI(model: Element) {
//
//    }
//}
