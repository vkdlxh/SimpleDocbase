//
//  Tag.swift
//  SimpleDocbase
//
//  Created by jeonsangjun on 2017/11/01.
//  Copyright © 2017年 jeon sangjun. All rights reserved.
//

import Foundation

struct Tag {
    var name: String
    
    init?(tag: [String: String]) {
        guard let name = tag["name"] else { return nil }
        
        self.name = name
    }
}
