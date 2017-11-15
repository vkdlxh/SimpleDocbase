//
//  ACAMemoRequest.swift
//  SimpleDocbase
//
//  Created by jeonsangjun on 2017/11/15.
//  Copyright © 2017年 archive-asia. All rights reserved.
//

import Foundation

class ACAMemoRequest: ACARequest {
    
    static var singletonMemoRequest = ACAMemoRequest()
    
    func MemoList(domain: String, group: String, completion: @escaping ([Memo]) -> ()) {
        print("MemoList(domain:, group:)")
        let urlStr = "https://api.docbase.io/teams/\(domain)/posts?q=group:\(group)"
        let encodedURL = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        guard let url = URL(string: encodedURL) else { return }
        
        let request = settingRequest(url: url, httpMethod: .get)
        
        session.dataTask(with: request) { (data, response, error) in
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                    var memos: [Memo]?
                    memos = []
                    for post in json["posts"] as! [Any] {
                        guard let memo = Memo(dict: post as! [String:Any]) else { return }
                        memos?.append(memo)
                        
                    }
                    if let memos = memos {
                        completion(memos)
                    }
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
}
