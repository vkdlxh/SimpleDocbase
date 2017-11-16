//
//  Memo.swift
//  SimpleDocbase
//
//  Created by jeonsangjun on 2017/11/01.
//  Copyright © 2017年 archive-asia. All rights reserved.
//

import Foundation

struct Memo {
    
    let id: Int
    let title: String
    let body: String
    let draft: Bool
    let url: String
    let created_at: String
    var tags = [Tag]()
    let scope: String
    var groups = [Group]()
    let user: User
    var comments = [Comment]()
    
    init?(dict: [String: Any]) {
        
        guard let id = dict["id"] as? Int else { return nil }
        guard let title = dict["title"] as? String else { return nil }
        guard let body = dict["body"] as? String else { return nil }
        guard let draft = dict["draft"] as? Bool else { return nil }
        guard let url = dict["url"] as? String else { return nil }
        guard let created_at = dict["created_at"] as? String else { return nil }
        
        if let items = dict["tags"] as? [[String: String]] {
            
            for item in items {
                
                if let tag = Tag(tag:item) {
                    tags.append(tag)
                }
            }
        } else { return nil }
        
        guard let scope = dict["scope"] as? String else { return nil }
        
        if let items = dict["groups"] as? [[String: Any]] {
            
            for item in items {
                
                if let group = Group(group: item) {
                    groups.append(group)
                }
            }
        } else { return nil }
        
        guard let userDict = dict["user"] as? [String: Any] else { return nil }
        guard let user = User(user: userDict) else { return nil }
        
        if let items = dict["comments"] as? [[String: Any]] {
            
            for item in items {
                if let comment = Comment(comment: item) {
                    comments.append(comment)
                }
            }
        } else { return nil }
        
        self.id = id
        self.title = title
        self.body = body
        self.draft = draft
        self.url = url
        self.created_at = created_at
        self.scope = scope
        self.user = user
    }
}

