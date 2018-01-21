//
//  ACARequest.swift
//  SimpleDocbase
//
//  Created by jeonsangjun on 2017/11/10.
//  Copyright © 2017年 archive-asia. All rights reserved.
//

import Foundation
import Firebase

class ACARequest {
    
    // MARK: Properties    
    var url: URL?
    let session: URLSession = URLSession.shared
    let fbManager = FBManager.sharedManager
    
    enum MethodType: String {
        case get    = "GET"
        case post   = "POST"
        case delete = "DELETE"
        case put    = "PUT"
        case patch  = "PATCH"
    }

    // MARK: Internal Methods
    func settingRequest(url: URL, httpMethod: MethodType, completion: @escaping ((URLRequest?) -> ())){
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        if fbManager.testMode == true {
            request.addValue(fbManager.testToken, forHTTPHeaderField: "X-DocBaseToken")
            completion(request)
        } else {
            if let apiToken = fbManager.apiToken {
                request.addValue(apiToken, forHTTPHeaderField: "X-DocBaseToken")
                completion(request)
                
            } else {
                completion(nil)
            }
        }
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
