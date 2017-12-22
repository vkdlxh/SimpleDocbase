//
//  ACACommentRequest.swift
//  SimpleDocbase
//
//  Created by jeonsangjun on 2017/12/22.
//  Copyright © 2017年 archive-asia. All rights reserved.
//

import Foundation

class ACACommentRequest: ACARequest {
    
    func writeComment(memoId: Int, domain: String, dict: Dictionary<String, String>, completion: @escaping (Bool) -> ()) {
        print("writeComment(memoId, domain: , dict: )")
        guard let url = URL(string: "https://api.docbase.io/teams/\(domain)/posts/\(memoId)/comments") else { return }
        
        var request = settingRequest(url: url, httpMethod: .post)
        guard let httpBody = try? JSONSerialization.data(withJSONObject: dict, options: []) else {
            return
        }
        request.httpBody = httpBody
        
        session.dataTask(with: request) { (data, response, error) in
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 201 {
                print("statusCode should be 201, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                completion(false)
            } else {
                completion(true)
            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                }catch {
                    print(error)
                }
            } else {
                completion(false)
                print("Write Comment Fail")
            }
            }.resume()
        
    }
}
