//
//  Team.swift
//  SimpleDocbase
//
//  Created by jeonsangjun on 2017/10/30.
//  Copyright © 2017年 archive-asia. All rights reserved.
//

import Foundation

struct Team {
    var domain: String
    var name: String
    
    init?(team: [String: String]) {
        guard let domain = team["domain"] else { return nil }
        guard let name = team["name"] else { return nil }
        
        self.domain = domain
        self.name = name
    }
}
