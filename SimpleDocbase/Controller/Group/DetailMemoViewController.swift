//
//  DetailMemoViewController.swift
//  SimpleDocbase
//
//  Created by jeonsangjun on 2017/11/23.
//  Copyright © 2017年 archive-asia. All rights reserved.
//

import UIKit
import SVProgressHUD
import Firebase

class DetailMemoViewController: UIViewController {
    
    // MARK: Properties
    var memoId = 0
    var memo: Memo?
    let domain = UserDefaults.standard.object(forKey: "selectedTeam") as? String
    var sectionList = ["Memo", "Comment"]
    //TestMode
    var testMode = false
    
    // MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint?
    @IBOutlet weak var keyboardView: UIView!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var writeCommentButton: UIButton!
    
    @IBAction func writeCommentAction(_ sender: Any) {
        
        if let comment = commentTextField.text, comment.isEmpty {
            failWriteCommentAlert()
        } else {
            let comment: [String: String] = ["body" : commentTextField.text!]
            commentTextField.text = ""
            if let domain = domain {
                ACACommentRequest().writeComment(memoId: memoId, domain: domain, dict: comment) { bool in
                    if bool == true {
                        DispatchQueue.main.async {
                            print("success write comment")
                            self.getMemoFromRequest()
                        }
                    }
                }
            }
        }
    }
    
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
        getMemoFromRequest()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(handelKeyboardNotification), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        notificationCenter.addObserver(self, selector: #selector(handelKeyboardNotification), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    
       initInputKeyboardView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkAccount()
    }
    
    // MARK: Internal Methods
    
    // MARK: Private Methods
    
    @objc private func handelKeyboardNotification(_ notification: Notification) {
        let userInfo = (notification as NSNotification).userInfo!
        let keyboardHeight =  (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        let isKeyboardShowing = notification.name == .UIKeyboardWillShow
        
        bottomConstraint?.constant = isKeyboardShowing ? -keyboardHeight.height : 0
        viewBottomConstraint.constant = isKeyboardShowing ? keyboardHeight.height : 0
        
        UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
            
            self.view.layoutIfNeeded()
            
        }) { (completed) in          
            if let comments = self.memo?.comments, !comments.isEmpty {
                let indexPath = IndexPath(item: comments.count - 1, section: 1)
                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            } else {
                let indexPath = IndexPath(item: 0, section: 0)
                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
 
    }
    
    private func initInputKeyboardView() {
        keyboardView.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11, *) {
            let guide = view.safeAreaLayoutGuide
            keyboardView.centerXAnchor.constraint(equalTo: guide.centerXAnchor).isActive = true
            keyboardView.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
            keyboardView.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
            bottomConstraint = keyboardView.bottomAnchor.constraint(equalTo: guide.bottomAnchor)
        } else {
            NSLayoutConstraint(item: keyboardView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 50).isActive = true
            NSLayoutConstraint(item: keyboardView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
            NSLayoutConstraint(item: keyboardView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
            bottomConstraint = NSLayoutConstraint(item: keyboardView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0)
        }
        view.addConstraint(bottomConstraint!)
        
        let viewTopBorder = UIView(frame: CGRect(x: 0,
                                                 y: 0,
                                                 width: keyboardView.frame.width,
                                                 height: 1
            )
        )
        viewTopBorder.backgroundColor = UIColor.lightGray
        keyboardView.addSubview(viewTopBorder)

        let origImage = UIImage(named: "Comments")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        writeCommentButton.setImage(tintedImage, for: .normal)
        writeCommentButton.tintColor = ACAColor().ACAOrange
    }
    
    
    private func checkAccount() {
        if testMode == false {
            if Auth.auth().currentUser == nil {
                let changedAccountAC = UIAlertController(title: "サインアウト", message: "サインアウトされました。", preferredStyle: .alert)
                let okButton = UIAlertAction(title: "確認", style: .default) { action in
                    self.navigationController!.popToRootViewController(animated: true)
                }
                changedAccountAC.addAction(okButton)
                present(changedAccountAC, animated: true, completion: nil)
            }
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


