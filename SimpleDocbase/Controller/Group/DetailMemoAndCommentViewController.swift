//
//  DetailMemoAndCommentViewController.swift
//  SimpleDocbase
//
//  Created by jeonsangjun on 2017/11/23.
//  Copyright © 2017年 archive-asia. All rights reserved.
//

import UIKit
import SwiftyMarkdown

class DetailMemoAndCommentViewController: UIViewController {
    
    // MARK: Properties
    var memo: Memo?
    var sectionList = ["Memo", "Comment"]
    
//    enum DetailMemo {
//        case Memo
//        case Commnet
//    }
    
    @IBOutlet weak var tableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
    }

}

extension DetailMemoAndCommentViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionTitle = sectionList[section]
        switch sectionTitle {
        case "Memo":
            return 1
        case "Comment":
            guard let commentCount = memo?.comments.count else {
                return 0
            }
            return commentCount
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionTitle = sectionList[indexPath.section]
        switch sectionTitle {
        case "Memo":
            if let cell = tableView.dequeueReusableCell(withIdentifier: "MemoCell", for: indexPath) as? DetailMemoCell {
                guard let memo = memo else {
                    return cell
                }
                cell.titleLabel.text = memo.title
                cell.bodyTextView.attributedText = SwiftyMarkdown(string: memo.body).attributedString()
                
                var groups: [String] = []
                for i in 0..<memo.groups.count{
                    groups.append(memo.groups[i].name)
                }
                cell.groupLabel.text = groups.joined(separator: ", ")
                
                var tags: [String] = []
                for i in 0..<memo.tags.count{
                    tags.append(memo.tags[i].name)
                }
                cell.tagLabel.text = tags.joined(separator: ", ")
                
                return cell
            }
        case "Comment":
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as? CommentCell {
                guard let comment = memo?.comments[indexPath.row] else {
                    return cell
                }
                guard let user = comment.user else {
                    return cell
                }
                let imageURL = URL(string: user.profile_image_url)
                let imageURLData = try? Data(contentsOf: imageURL!)
                cell.profileImageView.image = UIImage(data: imageURLData!)
                
                cell.bodyTextView.attributedText = SwiftyMarkdown(string: comment.body).attributedString()
                
                return cell
            }
        default:
            break
        }
        return UITableViewCell()
    }
    

}
