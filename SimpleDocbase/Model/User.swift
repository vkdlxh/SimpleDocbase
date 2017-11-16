//
//  User.swift
//  SimpleDocbase
//
//  Created by jeonsangjun on 2017/11/01.
//  Copyright © 2017年 archive-asia. All rights reserved.
//

import Foundation

struct User {
    let id: Int
    let name: String
    let profile_image_url: String
    
    init?(user: [String: Any]) {
        guard let id = user["id"] as? Int else { return nil }
        guard let name = user["name"] as? String else { return nil }
        guard let profile_image_url = user["profile_image_url"] as? String else { return nil }
        
        self.id = id
        self.name = name
        self.profile_image_url = profile_image_url
        
    }
}
