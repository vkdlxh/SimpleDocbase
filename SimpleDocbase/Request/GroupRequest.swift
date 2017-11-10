//
//  GroupRequest.swift
//  SimpleDocbase
//
//  Created by jeonsangjun on 2017/11/09.
//  Copyright © 2017年 jeon sangjun. All rights reserved.
//

import Foundation

class GroupRequest: Request {
    
    func getGroupFromTeam() {
        print("getGroupFromTeam()")
        guard let url = URL(string: "https://api.docbase.io/teams") else { return }
        
        let request = settingRequest(url: url, httpMethod: .get)
        
        session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: String]] {
                        if let teamListDomain = super.makeTeamDomainArray(dict: json){
                            if let domain = UserDefaults.standard.object(forKey: "selectedDomain") as? String {
                                self.getGroupList(domain: domain)
                            } else {
                                if let domain = teamListDomain.first {
                                    UserDefaults.standard.set(domain, forKey: "selectedDomain")
                                    self.getGroupList(domain: domain)
                                }
                            }
                        }
                    }
                } catch {
                    print(error)
                }
            }
        }.resume()
      
    }
    
    func getGroupList(domain: String) -> Void {
        print("getGroupList(domain: )")
        guard let url = URL(string: "https://api.docbase.io/teams/\(domain)/groups") else { return }
        
        let request = settingRequest(url: url, httpMethod: .get)
        
        session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                        
                        if let groupList = super.makeGroupArray(dict: json) {
                            guard let _ = self.delegate?.didRecivedGroup?(groups: groupList) else {
                                return
                            }
                            print("delegate getGroupName")
                        }
                    }
                } catch {
                    print(error)
                }
            }
        }.resume()
    }


}
