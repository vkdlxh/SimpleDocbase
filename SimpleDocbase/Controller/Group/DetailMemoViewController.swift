//
//  DetailMemoViewController.swift
//  SimpleDocbase
//
//  Created by jeonsangjun on 2017/11/23.
//  Copyright © 2017年 archive-asia. All rights reserved.
//

import UIKit

class DetailMemoViewController: UIViewController {
    
    // MARK: Properties
    var memo: Memo?
    var sectionList = ["Memo", "Comment"]
    let presentToken = UserDefaults.standard.object(forKey: "paramTokenKey") as? String
    
    // MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkTokenKey()
    }
    
    private func checkTokenKey() {
        let newToken = UserDefaults.standard.object(forKey: "paramTokenKey") as? String
        
        if presentToken != newToken {
            // TODO: トークン変更アラート
            let changedTokenAC = UIAlertController(title: "APIトークン変更", message: "APIトークンが変更されて\n最初の画面に戻ります。", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "確認", style: .default) { action in
                self.navigationController!.popToRootViewController(animated: true)
            }
            changedTokenAC.addAction(okButton)
            present(changedTokenAC, animated: true, completion: nil)
            
        }
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
