//
//  TeamRequest.swift
//  SimpleDocbase
//
//  Created by jeonsangjun on 2017/11/10.
//  Copyright © 2017年 jeon sangjun. All rights reserved.
//

import Foundation

class TeamRequest: Request {
    
    func getTeamList() {
        print("getTeamList()")
        guard let url = URL(string: "https://api.docbase.io/teams") else { return }
        
        let request = settingRequest(url: url, httpMethod: .get)
        
        session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: String]] {
                        
                        if let teamList = super.makeTeamDomainArray(dict: json){
                            
                            guard let _ = self.delegate?.didRecivedTeamList?(teams: teamList) else {
                                return
                            }
                            print("delegate didRevivedTeamList")
                        }
                    }
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
}
