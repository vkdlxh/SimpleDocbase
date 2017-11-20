//
//  ACAMemoRequest.swift
//  SimpleDocbase
//
//  Created by jeonsangjun on 2017/11/15.
//  Copyright © 2017年 archive-asia. All rights reserved.
//

import Foundation

class ACAMemoRequest: ACARequest {
    
    func getMemoList(domain: String, group: String, pageNum: Int, completion: @escaping ([Memo]?) -> ()) {
        print("getMemoList(domain:,group:,pageNum:)")
        let urlStr = "https://api.docbase.io/teams/\(domain)/posts?page=\(pageNum)&per_page=20&q=group:\(group)"
        let encodedURL = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        guard let url = URL(string: encodedURL) else { return }
        
        let request = settingRequest(url: url, httpMethod: .get)
        
        session.dataTask(with: request) { (data, response, error) in
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                    var memos: [Memo] = []
                    for post in json["posts"] as! [Any] {
                        guard let memo = Memo(dict: post as! [String:Any]) else { return }
                        memos.append(memo)
                    }
                    completion(memos)

                } catch {
                    print(error)
                    completion(nil)
                }
            }
        }.resume()
    }
    
    func writeMemo(domain: String, dict: Dictionary<String, Any>) {
        print("writeMemo(domain: , dict: )")
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
    
}
