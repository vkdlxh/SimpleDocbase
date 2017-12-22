//
//  DetailMemoViewController.swift
//  SimpleDocbase
//
//  Created by jeonsangjun on 2017/11/23.
//  Copyright © 2017年 archive-asia. All rights reserved.
//

import UIKit
import SVProgressHUD

class DetailMemoViewController: UIViewController {
    
    // MARK: Properties
//    var memo: Memo? {
//        didSet {
//            guard let memo = memo else {
//                return
//            }
//            memoId = memo.id
//        }
//    }
    var memoId = 0
    var memo: Memo?
    let domain = UserDefaults.standard.object(forKey: "selectedTeam") as? String
    var sectionList = ["Memo", "Comment", "WriteComment"]
    let presentToken = UserDefaults.standard.object(forKey: "tokenKey") as? String
    
    // MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        getMemoFromRequest()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkTokenKey()
    }
    
    // MARK: Internal Methods
    
    // MARK: Private Methods
    private func checkTokenKey() {
        let newToken = UserDefaults.standard.object(forKey: "tokenKey") as? String
        
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
    
    private func failWriteCommentAlert() {
            let failAC = UIAlertController(title: "コメント投稿失敗", message: "コメントは空欄無く入力してください。", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "確認", style: .default)
            failAC.addAction(okButton)
            present(failAC, animated: true, completion: nil)
            
    }
    
    private func getMemoFromRequest() {
        if let domian = domain {
            SVProgressHUD.show()
            DispatchQueue.global().async {
                ACAMemoRequest().getMemo(memoId: self.memoId, domain: domian) { memo in
                    self.memo = memo
                    DispatchQueue.main.async {
                        self.view.endEditing(true)
                        self.tableView.reloadData()
                        SVProgressHUD.dismiss()
                    }
                }
            }
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
        case "WriteComment":
            return 1
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
        case "WriteComment":
            if let cell = tableView.dequeueReusableCell(withIdentifier: "WriteCommentCell", for: indexPath) as? WriteCommentCell {
                cell.memoId = memoId
                cell.delegate = self
                return cell
            }
        default:
            break
        }
        return UITableViewCell()
    }
    
}

extension DetailMemoViewController: WriteCommentCellDelegate {
    func successWriteComment() {
        getMemoFromRequest()
    }
    
    func failWriteComment() {
        failWriteCommentAlert()
    }
}
