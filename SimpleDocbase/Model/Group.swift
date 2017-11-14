//
//  Group.swift
//  SimpleDocbase
//
//  Created by jeonsangjun on 2017/10/30.
//  Copyright © 2017年 archive-asia. All rights reserved.
//

import Foundation

struct Group {
    var id: Int
    var name: String
    
    init?(group: [String: Any]) {
        guard let id = group["id"] as? Int else { return nil }
        guard let name = group["name"] as? String else { return nil }
        
        self.id = id
        self.name = name
    }
}
