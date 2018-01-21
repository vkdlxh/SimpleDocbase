//
//  ACAGroupRequest.swift
//  SimpleDocbase
//
//  Created by jeonsangjun on 2017/11/15.
//  Copyright © 2017年 archive-asia. All rights reserved.
//

import Foundation

class ACAGroupRequest: ACARequest {
    
    func getGroupList(completion: @escaping ([Group]?) -> ()) {
        print("getGroupList()")
        ACATeamRequest.init().getTeamList() { (teams: [String]?) in
            var domain = UserDefaults.standard.object(forKey: "selectedTeam") as? String
            
            if domain == nil {
                UserDefaults.standard.set(teams?.first, forKey: "selectedTeam")
                domain = UserDefaults.standard.object(forKey: "selectedTeam") as? String
            }
            
            if let domain = domain {
                if let url = URL(string: "https://api.docbase.io/teams/\(domain)/groups") {
                    self.url = url
                }
            }
            
            if let url = self.url {
                self.settingRequest(url: url, httpMethod: .get) { request in
                    if let request = request {
                        self.session.dataTask(with: request) { (data, response, error) in
                            if let data = data {
                                do {
                                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                                        
                                        if let groupList = self.makeGroupArray(dict: json) {
                                            completion(groupList)
                                        }
                                    } else {
                                        print("Can't GroupList JSON parse")
                                        completion(nil)
                                    }
                                } catch {
                                    print(error)
                                    completion(nil)
                                }
                            }
                            }.resume()
                    } else {
                        completion(nil)
                    }
                    }
                } else {
                print("No URL -> Check TeamRequest")
                completion(nil)
            }
        }
    }
    
}
