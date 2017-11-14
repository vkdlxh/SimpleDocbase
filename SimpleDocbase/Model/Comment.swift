//
//  Comment.swift
//  SimpleDocbase
//
//  Created by jeonsangjun on 2017/11/01.
//  Copyright © 2017年 archive-asia. All rights reserved.
//

import Foundation

struct Comment {
    let id: Int
    let body: String
    let created_at: String
    let user: User?
    
    init?(comment: [String: Any]) {
        guard let id = comment["id"] as? Int else { return nil }
        guard let body = comment["body"] as? String else { return nil }
        guard let created_at = comment["created_at"] as? String else { return nil }
        guard let userDict = comment["user"] as? [String: Any] else { return nil }
        guard let user = User(user: userDict) else { return nil }
        
        self.id = id
        self.body = body
        self.created_at = created_at
        self.user = user
    }
}
