//
//  GroupList.swift
//  SimpleDocbase
//
//  Created by jeon sangjun on 2017/10/27.
//  Copyright © 2017年 jeon sangjun. All rights reserved.
//

import Foundation

struct GroupList {
    var groups = [String]()
    
    init?(dict: [[String: Any]]) {
        
        for group in dict {
            if let group = Group(group:group) {
                
                groups.append(group.name)
            }
        }
    }
}

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
