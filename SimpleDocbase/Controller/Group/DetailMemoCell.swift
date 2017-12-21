//
//  DetailMemoCell.swift
//  SimpleDocbase
//
//  Created by jeonsangjun on 2017/11/23.
//  Copyright © 2017年 archive-asia. All rights reserved.
//

import UIKit
import SwiftyMarkdown

class DetailMemoCell: UITableViewCell {
    
    //MARK: IBOutlet
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var groupLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var groupImageView: UIImageView!
    @IBOutlet weak var tagImageView: UIImageView!
    
    var memo: Memo? {
        didSet {
            guard let memo = memo else {
                return
            }
            
            titleLabel.text = memo.title
            if memo.title.hasPrefix("SimpleDocbase_") {
                bodyTextView.text = "勤務表はDocbaseから確認してください。"
                bodyTextView.font = UIFont.boldSystemFont(ofSize: 20)
            } else {
                bodyTextView.attributedText = SwiftyMarkdown(string: memo.body).attributedString()
            }
            
            var groups: [String] = []
            for i in 0..<memo.groups.count{
                groups.append(memo.groups[i].name)
            }
            groupLabel.text = groups.joined(separator: ", ")
            
            
            if memo.tags.isEmpty {
                tagImageView.isHidden = true
                tagLabel.text?.removeAll()
            } else {
                var tags: [String] = []
                for i in 0..<memo.tags.count{
                    tags.append(memo.tags[i].name)
                }
                tagLabel.text = tags.joined(separator: ", ")
            }
        }
    }
    
    //MARK: Life cycle
    override func awakeFromNib() {
        self.selectionStyle = .none
        
        if let tagImage = UIImage(named: "Tag") {
            let tintableImage = tagImage.withRenderingMode(.alwaysTemplate)
            tagImageView.image = tintableImage
            tagImageView.tintColor = ACAColor().ACAApricot
        }
        if let groupImage = UIImage(named: "People") {
            let tintableImage = groupImage.withRenderingMode(.alwaysTemplate)
            groupImageView.image = tintableImage
            groupImageView.tintColor = ACAColor().ACAApricot
        }
    }
    
}
