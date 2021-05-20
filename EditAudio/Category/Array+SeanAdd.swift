//
//  Array+SeanAdd.swift
//  MagFxBx
//
//  Created by yoyochecknow on 2021/4/17.
//  Copyright © 2021 MacBook. All rights reserved.
//

import Foundation

extension Array{
    subscript(safe index:Int) -> Element? {
        if self.count > index {
            return self[index]
        }
        return nil
    }
}
