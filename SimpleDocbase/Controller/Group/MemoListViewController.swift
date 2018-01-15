//
//  MemoListViewController.swift
//  SimpleDocbase
//
//  Created by jeonsangjun on 2017/11/01.
//  Copyright © 2017年 archive-asia. All rights reserved.
//

import UIKit
import SVProgressHUD
import Firebase

class MemoListViewController: UIViewController {
    
    // MARK: Properties
    var group: Group?
    let domain = UserDefaults.standard.object(forKey: "selectedTeam") as? String
    let presentToken = UserDefaults.standard.object(forKey: "tokenKey") as? String
    var memos = [Memo]()
    var refreshControl: UIRefreshControl!
    //Pagination
    var isDataLoading:Bool = false
    var pageNum: Int = 1
    let perPage: Int = 20
    //TestMode
    var testMode = false
    

    // MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageLabel: UILabel!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = group?.name
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(addTapped(sender:)))
        refreshControlAction()
        SVProgressHUD.show(withStatus: "更新中")
        if let domain = domain {
            if let groupName = group?.name {
                ACAMemoRequest().getMemoList(domain: domain, group: groupName, pageNum: pageNum, perPage: perPage) { memos in
                    if let memos = memos {
                        self.memos = memos
                        DispatchQueue.main.async {
                            SVProgressHUD.dismiss()
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkAccount()
        tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: Internal Methods
    
    // MARK: Private Methods
    @objc private func addTapped(sender: UIBarButtonItem) {
        performSegue(withIdentifier: "GoWriteMemoSegue", sender: self)
    }
    
    private func refreshControlAction() {
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "引っ張って更新")
        self.refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.tableView.addSubview(refreshControl)
    }
    
    private func deleteMemoAlert(completion: @escaping (Bool) -> ()) {
        let deleteMemoAC = UIAlertController(title: "メモ削除", message: "メモを削除しますか？", preferredStyle: .alert)
        let deleteButton = UIAlertAction(title: "削除", style: .default) { action in
            completion(true)
            print("tapped Memo delete Button")
        }
        let cancelButton = UIAlertAction(title: "キャンセル", style: .cancel) { action in
            completion(false)
            print("tapped Memo cancel Button")
        }
        
        deleteMemoAC.addAction(deleteButton)
        deleteMemoAC.addAction(cancelButton)
        present(deleteMemoAC, animated: true, completion: nil)
    }
    
    private func deleteFailAlert() {
        let deleteFailAC = UIAlertController(title: "削除失敗", message: "削除する権限がありません。", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "削除", style: .default) { action in
            print("tapped Delete Fail OK Button")
        }
        deleteFailAC.addAction(okButton)
        present(deleteFailAC, animated: true, completion: nil)
    }
    
    @objc private func refresh() {
        pageNum = 1
        if let domain = domain {
            if let groupName = group?.name {
                ACAMemoRequest().getMemoList(domain: domain, group: groupName, pageNum: pageNum, perPage: perPage) { memos in
                    if let memos = memos {
                        self.memos = memos
                        DispatchQueue.main.async {
                            self.refreshControl.endRefreshing()
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoDetailMemoSegue" {
            if let destination = segue.destination as? DetailMemoViewController {
                if let selectedIndex = self.tableView.indexPathForSelectedRow?.row {
                    destination.memoId = memos[selectedIndex].id
                    destination.memo = memos[selectedIndex]
                    destination.testMode = testMode
                }
            }
        } else if segue.identifier == "GoWriteMemoSegue" {
            if let destination = segue.destination as? UINavigationController {
                if let tagetController = destination.topViewController as? WriteMemoViewController {
                    tagetController.delegate = self
                    tagetController.group = self.group
                    tagetController.testMode = testMode
                }
            }
        }
    }
}


// MARK: Extensions
extension MemoListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if memos.isEmpty {
            messageLabel.isHidden = false
            tableView.separatorStyle = .none
        } else {
            messageLabel.isHidden = true
            tableView.separatorStyle = .singleLine
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MemoCell", for: indexPath) as? MemoListCell {
            cell.delegate = self
            let memo = memos[indexPath.row]
            cell.memo = memo
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteButton: UITableViewRowAction = UITableViewRowAction(style: .normal, title: "削除") { (action, index) -> Void in
            let memoNum = self.memos[indexPath.row].id
            self.deleteMemoAlert(completion: { checkBtn in
                if checkBtn == true {
                    self.tableView.beginUpdates()
                    DispatchQueue.global().async {
                        if let domain = self.domain {
                            ACAMemoRequest().delete(domain: domain, num: memoNum) { response in
                                if response == true {
                                    print("Memo Deleted")
                                    
                                    self.memos.remove(at: indexPath.row)
                                    DispatchQueue.main.async {
                                        self.tableView.deleteRows(at: [indexPath], with: .automatic)
                                        self.tableView.endUpdates()
                                    }
                                } else {
                                    // TODO: 失敗
                                    self.deleteFailAlert()
                                }
                            }
                        }
                    }
                    
                } else {
                    tableView.setEditing(false, animated: true)
                }
            })
        }
        
        deleteButton.backgroundColor = UIColor.red
        
        return [deleteButton]
    }
}

extension MemoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.backgroundColor = UIColor.lightGray.withAlphaComponent(0.50)
        }
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.backgroundColor = .clear
        }
    }
}

extension MemoListViewController: WriteMemoViewControllerDelegate {
    
    func writeMemoViewSubmit() {
        dismiss(animated: true, completion: nil)
        refresh()
    }
}

extension MemoListViewController: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("scrollViewWillBeginDragging")
        isDataLoading = false
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("scrollViewDidEndDragging")
        if scrollView == tableView {
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height) && self.memos.count > 4{
                if !isDataLoading{
                    SVProgressHUD.show(withStatus: "更新中")
                    isDataLoading = true
                    if let domain = domain {
                        if let groupName = group?.name {
                            self.pageNum += 1
                            ACAMemoRequest().getMemoList(domain: domain, group: groupName, pageNum: pageNum, perPage: perPage) { memos in
                                if let memos = memos {
                                    self.memos += memos
                                }
                                
                                DispatchQueue.main.async {
                                    SVProgressHUD.dismiss()
                                    self.tableView.reloadData()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
}

extension MemoListViewController: MemoListCellDelegate {
    func emptyTag(image: UIImageView) {
//        tableView.addSubview(image)
        tableView.layoutIfNeeded()
    }
    
    
}

