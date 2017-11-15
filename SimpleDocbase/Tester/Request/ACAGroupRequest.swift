//
//  ACAGroupRequest.swift
//  SimpleDocbase
//
//  Created by jeonsangjun on 2017/11/15.
//  Copyright © 2017年 archive-asia. All rights reserved.
//

import Foundation

class ACAGroupRequest: ACARequest {
    
    static var singletonGroupRequest = ACAGroupRequest()
    
    func getGroupClosure(completion: @escaping ([Group]) -> ()) {
        print("getGroupClosure()")
        ACATeamRequest.singletonTeamRequest.getTeamListClosure() { (teams: [String]) in
            let domain = UserDefaults.standard.object(forKey: "selectedDomain") as? String
            
            if domain == nil {
                UserDefaults.standard.set(teams.first, forKey: "selectedDomain")
            }
            
            if let domain = domain {
                if let url = URL(string: "https://api.docbase.io/teams/\(domain)/groups") {
                    self.url = url
                }
            }
            
            if let url = self.url {
                let request = self.settingRequest(url: url, httpMethod: .get)
                
                self.session.dataTask(with: request) { (data, response, error) in
                    if let data = data {
                        do {
                            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                                
                                if let groupList = self.makeGroupArray(dict: json) {
                                    completion(groupList)
                                }
                            }
                        } catch {
                            print(error)
                        }
                    }
                }.resume()
            }
        }
    }
    
}
