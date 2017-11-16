//
//  ACATeamRequest.swift
//  SimpleDocbase
//
//  Created by jeonsangjun on 2017/11/15.
//  Copyright © 2017年 archive-asia. All rights reserved.
//

import Foundation

class ACATeamRequest: ACARequest {

    func getTeamListClosure(completion: @escaping ([String]?) -> ()) {
        print("getTeamListClosure()")
        guard let url = URL(string: "https://api.docbase.io/teams") else { return }
        
        let request = settingRequest(url: url, httpMethod: .get)
        
        session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: String]] {
                        if let teamList = self.makeTeamDomainArray(dict: json){
                            
                            completion(teamList)
                        }
                    }
                } catch {
                    print(error)
                    completion(nil)
                }
            }
        }.resume()
    }
}
