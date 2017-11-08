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
    @objc optional func getGroupName(groups: Array<Any>)
    @objc optional func getMemoList(memos: Array<Any>)
}

class Request {
    
    // MARK: Properties
    let session: URLSession = URLSession.shared
    var delegate: RequestDelegate?
    let paramTokenKey = UserDefaults.standard.object(forKey: "paramTokenKey") as? String
    // TokenKey : 8ZwKUqC7QkJJKZN2hP2i
    let semaphore = DispatchSemaphore(value: 0)
    
    
    enum MethodType: String {
        case get = "GET"
        case post = "POST"
        case delete = "DELETE"
        case put = "PUT"
        case patch = "PATCH"
    }
    
    // MARK: Internal Methods
    
//    func getGroupFromTeam(domain: String) {
//        let queue = DispatchQueue(label: "label")
//        queue.async {
//            self.getTeamList()
//            self.groupList(domain: domain)
//            
//            DispatchQueue.main.async {
//                <#code#>
//            }
//        }
//    }
    
    func getTeamList() {
        
        guard let url = URL(string: "https://api.docbase.io/teams") else { return }
    
        let request = settingRequest(url: url, httpMethod: .get)
    
        session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                print("TeamList OK")
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: String]] {
                        
                        if let teamList = self.getTeamDomain(dict: json){
                            
                            guard let _ = self.delegate?.didRecivedTeamList?(teams: teamList) else {
                                return
                            }
                        }
//                        self.semaphore.signal()
                        print("delegate didRevivedTeamList")
                    }
                } catch {
                print(error)
                }
            }
            
        }.resume()
//        self.semaphore.wait()
    }
    
    func groupList(domain: String) -> Void {
        
        guard let url = URL(string: "https://api.docbase.io/teams/\(domain)/groups") else { return }
        
        let request = settingRequest(url: url, httpMethod: .get)
        
        session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                do {
                    print("GroupList OK")
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                        
                        if let groupList = self.getGroupList(dict: json) {
                            guard let _ = self.delegate?.getGroupName?(groups: groupList) else {
                                return
                            }
                        }
                        
//                        self.semaphore.signal()
                        print("delegate getGroupName")
                    }
                } catch {
                    print(error)
                }
            }
        }.resume()
//        self.semaphore.wait()
    }
    
    func MemoList(domain: String, group: String) -> Void {
        
        let urlStr = "https://api.docbase.io/teams/\(domain)/posts?q=group:\(group)"
        let encodedURL = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        guard let url = URL(string: encodedURL) else { return }
        
        let request = settingRequest(url: url, httpMethod: .get)
        
        session.dataTask(with: request) { (data, response, error) in
   
            if let data = data {
                do {
                    print("getMemoList OK")
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                    var memos = [Any]()
                    for post in json["posts"] as! [Any] {
                        
                        guard let memo = Memo(dict: post as! [String:Any]) else { return }
                        memos.append(memo)
                       
                    }
                    guard let _ = self.delegate?.getMemoList?(memos: memos) else { return }
                    
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
    func writeMemo(domain: String, dict: Dictionary<String, Any>) {
         guard let url = URL(string: "https://api.docbase.io/teams/\(domain)/posts") else { return }
        
        var request = settingRequest(url: url, httpMethod: .post)
        guard let httpBody = try? JSONSerialization.data(withJSONObject: dict, options: []) else {
            return
        }
        request.httpBody = httpBody
        
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                }catch {
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
    
    private func getGroupList(dict: [[String: Any]]) -> [Group]?{
        var groups = [Group]()
        
        for group in dict {
            if let group = Group(group:group) {
                
                groups.append(group)
            }
        }
        return groups
    }
    
}
