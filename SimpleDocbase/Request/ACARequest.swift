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
    var ref: DatabaseReference!
//    let tokenKey = UserDefaults.standard.object(forKey: "tokenKey") as? String
    
    enum MethodType: String {
        case get    = "GET"
        case post   = "POST"
        case delete = "DELETE"
        case put    = "PUT"
        case patch  = "PATCH"
    }
    
    func getAPITokenFromDatabase(completion: @escaping ((String?) -> ())) {
        ref = Database.database().reference()
        if let userID = Auth.auth().currentUser?.uid {
            self.ref.child("users").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as? NSDictionary
                let apiToken = value?["apiToken"] as? String ?? ""
                DispatchQueue.main.async {
                    completion(apiToken)
                }
        
            }) { (error) in
                print(error.localizedDescription)
            }
        } else {
            completion(nil)
        }
    }

    // MARK: Internal Methods
    func settingRequest(url: URL, httpMethod: MethodType, completion: @escaping ((URLRequest?) -> ())){
        var request: URLRequest = URLRequest(url: url)
        
        getAPITokenFromDatabase { token in
            request.httpMethod = httpMethod.rawValue
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            self.getAPITokenFromDatabase { token in
                if let token = token {
                    request.addValue(token, forHTTPHeaderField: "X-DocBaseToken")
                    completion(request)
                } else {
                    completion(nil)
                }
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
