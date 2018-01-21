//
//  ACATeamRequest.swift
//  SimpleDocbase
//
//  Created by jeonsangjun on 2017/11/15.
//  Copyright © 2017年 archive-asia. All rights reserved.
//

import Foundation

class ACATeamRequest: ACARequest {

    func getTeamList(completion: @escaping ([String]?) -> ()) {
        print("getTeamList()")
        guard let url = URL(string: "https://api.docbase.io/teams") else { return }
        
        settingRequest(url: url, httpMethod: .get) { request in
            if let request = request {
                self.session.dataTask(with: request) { (data, response, error) in
                    if let data = data {
                        do {
                            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: String]] {
                                if let teamList = self.makeTeamDomainArray(dict: json){
                                    completion(teamList)
                                }
                            } else {
                                print("Can't TeamList JSON parse")
                                completion(nil)
                            }
                        } catch {
                            print(error)
                            completion(nil)
                        }
                    } else {
                        print("TeamList No data. Check TokenKey")
                        UserDefaults.standard.set(nil, forKey: "selectedTeam")
                        completion(nil)
                    }
                    }.resume()
            } else {
                completion(nil)
            }
        }
    }
}
