//
//  Request.swift
//  SimpleDocbase
//
//  Created by jeon sangjun on 2017/10/27.
//  Copyright © 2017年 jeon sangjun. All rights reserved.
//

import Foundation

@objc protocol RequestDelegate {
    @objc optional func didRecivedTeamList(teams: Array<String>)
    @objc optional func getGroupName(groups: Array<String>)
//    @objc optional func getMemoList(memo: Memo)
}

class Request {
    
    // MARK: Properties
    let session: URLSession = URLSession.shared
    var delegate: RequestDelegate?
    let paramTokenKey = UserDefaults.standard.object(forKey: "paramTokenKey") as? String
    // TokenKey : 8ZwKUqC7QkJJKZN2hP2i
    
    

    enum MethodType: String {
        case get = "GET"
        case post = "POST"
        case delete = "DELETE"
        case put = "PUT"
        case patch = "PATCH"
    }
    
    // MARK: Internal Methods
    func getTeamList() {
        
        guard let url = URL(string: "https://api.docbase.io/teams") else { return }
    
        let request = settingRequest(url: url, httpMethod: .get)
    
        session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                print(data)
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: String]] {
                        
                        if let teamList = self.getTeamDomain(dict: json){
                            
                            guard let team = self.delegate?.didRecivedTeamList?(teams: teamList) else {
                                return
                            }
                            
                            
                        }
                    }
                } catch {
                print(error)
                }
            }
        }.resume()
        
    }
    
    func groupList(domain: String) -> Void {
        
        guard let url = URL(string: "https://api.docbase.io/teams/\(domain)/groups") else { return }
        
        let request = settingRequest(url: url, httpMethod: .get)
        
        session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                print(data)
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                        
                        if let groupList = self.getGroupList(dict: json) {
                           
                            guard let groupName = self.delegate?.getGroupName?(groups: groupList) else {
                                return
                            }
                        }
                    }
                } catch {
                    print(error)
                }
            }
            }.resume()
        
    }
    
    func MemoList(domain: String, group: String) -> Void {
        
        guard let url = URL(string: "https://api.docbase.io/teams/\(domain)/posts?q=group:\(group)") else { return }
        
        let request = settingRequest(url: url, httpMethod: .get)
        
        session.dataTask(with: request) { (data, response, error) in
   
            if let data = data {
                print(data)
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                    
                    for post in json["posts"] as! [Any] {
                        
                        let memo = Memo(dict: post as! [String:Any])
                        
                       
                    }
                } catch {
                    print(error)
                }
            }
            }.resume()
    }
    
    
    // MARK: Private Methods
    private func settingRequest(url: URL, httpMethod: MethodType) -> URLRequest {
        
        var request: URLRequest = URLRequest(url: url)
        
        request.httpMethod = httpMethod.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        if let tokenKey = paramTokenKey {
          request.addValue(tokenKey, forHTTPHeaderField: "X-DocBaseToken")
        }
        
        return request
    }
    
    private func getTeamDomain(dict: [[String : String]]) -> [String]?{
        var teams = [String]()
        
        for team in dict {
            if let team = Team(team:team) {
                
                teams.append(team.domain)
            }
        }
        return teams
    }
    
    
    private func getGroupList(dict: [[String: Any]]) -> [String]?{
        var groups = [String]()
        
        for group in dict {
            if let group = Group(group:group) {
                
                groups.append(group.name)
            }
        }
        return groups
    }
    
}
