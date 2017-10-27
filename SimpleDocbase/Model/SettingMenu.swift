//
//  SettingMenu.swift
//  SimpleDocbase
//
//  Created by jeon sangjun on 2017/10/25.
//  Copyright © 2017年 jeon sangjun. All rights reserved.
//

import Foundation

class SettingMenu{
    let name: String
    var service: [SettingItem]?
    
    init(name: String) {
        self.name = name
    }
}

class SettingItem {
    let name: String
    let item: String
    
    init(name: String, item: String) {
        self.name = name
        self.item = item
    }
}
