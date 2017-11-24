//
//  DetailMemoViewController.swift
//  SimpleDocbase
//
//  Created by jeonsangjun on 2017/11/23.
//  Copyright © 2017年 archive-asia. All rights reserved.
//

import UIKit
import SwiftyMarkdown

class DetailMemoViewController: UIViewController {
    
    // MARK: Properties
    var memo: Memo?
    var sectionList = ["Memo", "Comment"]
    
    // MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
    }

}

// MARK: Extensions
extension DetailMemoViewController: UITableViewDataSource {
    
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
                cell.memo = memo
                return cell
            }
        case "Comment":
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as? CommentCell {
                guard let comment = memo?.comments[indexPath.row] else {
                    return cell
                }
                cell.comment = comment
                return cell
            }
        default:
            break
        }
        return UITableViewCell()
    }
    

}
