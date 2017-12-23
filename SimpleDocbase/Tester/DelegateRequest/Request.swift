//
//  Request.swift
//  SimpleDocbase
//
//  Created by jeon sangjun on 2017/10/27.
//  Copyright © 2017年 archive-asia. All rights reserved.
//

import Foundation

@objc protocol RequestDelegate {
    @objc optional func didRecivedTeamList(teams: Array<String>)
    @objc optional func didRecivedGroup(groups: Array<Any>)
    @objc optional func getMemoList(memos: Array<Any>)
}

class Request {
    
    // MARK: Properties
    let session: URLSession = URLSession.shared
    var delegate: RequestDelegate?
    let tokenKey = UserDefaults.standard.object(forKey: "tokenKey") as? String
    
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
    
    func makeGroupArray(dict: [[String: Any]]) -> [Group]?{
        var groups = [Group]()
        
        for group in dict {
            if let group = Group(group:group) {
                groups.append(group)
            }
        }
        return groups
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
}
