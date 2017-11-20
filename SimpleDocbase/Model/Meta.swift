//
//  Meta.swift
//  SimpleDocbase
//
//  Created by jeonsangjun on 2017/11/20.
//  Copyright © 2017年 archive-asia. All rights reserved.
//

import Foundation

struct Meta {
    
    let previous_page: String
    let next_page: String
    let total: Int
    
    init?(meta: [String: Any]) {
        guard let previous_page = meta["previous_page"] as? String else { return nil }
        guard let next_page = meta["next_page"] as? String else { return nil }
        guard let total = meta["total"] as? Int else { return nil }
        
        self.previous_page = previous_page
        self.next_page = next_page
        self.total = total
        
    }
    
}
