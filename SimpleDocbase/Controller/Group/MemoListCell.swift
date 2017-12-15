//
//  MemoListCell.swift
//  SimpleDocbase
//
//  Created by jeonsangjun on 2017/11/20.
//  Copyright © 2017年 archive-asia. All rights reserved.
//

import UIKit

class MemoListCell: UITableViewCell {
    
    // MARK: IBOutlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var tagImageView: UIImageView!
    
    
    var memo: Memo? {
        didSet {
            guard let memo = memo else {
                return
            }
            titleLabel.text = memo.title
            
            if memo.title.hasPrefix("SimpleDocbase_") {
                bodyLabel.text = "勤務表はDocbaseから確認してください。"
            } else {
                bodyLabel.text = memo.body
            }
            
            if memo.tags.isEmpty {
                tagImageView.isHidden = true
//                tagImageView.frame.width = 0
            }
            
            var tags: [String] = []
            for i in 0..<memo.tags.count{
                tags.append(memo.tags[i].name)
            }
            tagLabel.text = tags.joined(separator: ", ")
            
            let imageURL = URL(string: memo.user.profile_image_url)
            let imageURLData = try? Data(contentsOf: imageURL!)
            profileImageView.image = UIImage(data: imageURLData!)
        }
    }
}

