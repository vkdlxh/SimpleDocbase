//
//  ACARequest.swift
//  SimpleDocbase
//
//  Created by jeonsangjun on 2017/11/10.
//  Copyright © 2017年 archive-asia. All rights reserved.
//

import Foundation

class ACARequest {
    
    // MARK: Properties
    static var singletonRequest = ACARequest()
    
    var url: URL?
    let session: URLSession = URLSession.shared
    let tokenKey = UserDefaults.standard.object(forKey: "paramTokenKey") as? String
    
    enum MethodType: String {
        case get = "GET"
        case post = "POST"
        case delete = "DELETE"
        case put = "PUT"
        case patch = "PATCH"
    }

    // MARK: Internal Methods
    func settingRequest(url: URL, httpMethod: MethodType) -> URLRequest {
        
        var request: URLRequest = URLRequest(url: url)
        
        request.httpMethod = httpMethod.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        if let tokenKey = tokenKey {
            request.addValue(tokenKey, forHTTPHeaderField: "X-DocBaseToken")
        }
        return request
    }
    
    func makeTeamDomainArray(dict: [[String : String]]) -> [String]?{
        var teams = [String]()
        
        for team in dict {
            if let team = Team(team:team) {
                teams.append(team.domain)
            }
        }
        return teams
    }
    
    func makeGroupArray(dict: [[String: Any]]) -> [Group]?{
        var groups = [Group]()
        
        for group in dict {
            if let group = Group(group:group) {
                groups.append(group)
            }
        }
        return groups
    }
    
}
