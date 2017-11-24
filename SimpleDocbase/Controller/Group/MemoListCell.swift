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
    
    var memo: Memo? {
        didSet {
            guard let memo = memo else {
                return
            }
            
            titleLabel.text = memo.title
            bodyLabel.text = memo.body
            
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

