//
//  MemoListViewController.swift
//  SimpleDocbase
//
//  Created by jeonsangjun on 2017/11/01.
//  Copyright © 2017年 archive-asia. All rights reserved.
//

import UIKit
import SVProgressHUD

class MemoListViewController: UIViewController {
    
    // MARK: Properties
    var group: Group?
    let domain = UserDefaults.standard.object(forKey: "selectedTeam") as? String
    var memos = [Memo]()
    var refreshControl: UIRefreshControl!
    //Pagination
    var isDataLoading:Bool = false
    var pageNum: Int = 1
    let perPage: Int = 20

    // MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
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
                    }
                    self.pageNum += 1
                    DispatchQueue.main.async {
                        SVProgressHUD.dismiss()
                        self.tableView.reloadData()
                    }
                }
            }
        }
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
        let deleteMemoAC = UIAlertController(title: "Memo削除", message: "Memoを削除しますか？", preferredStyle: .alert)
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
                    }
                }
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoDetailMemoSegue" {
            if let destination = segue.destination as? DetailMemoViewController {
                if let selectedIndex = self.tableView.indexPathForSelectedRow?.row {
                    destination.memo = memos[selectedIndex]
                }
            }
        } else if segue.identifier == "GoWriteMemoSegue" {
            if let destination = segue.destination as? UINavigationController {
                if let tagetController = destination.topViewController as? WriteMemoViewController {
                    tagetController.delegate = self
                    tagetController.group = self.group
                }
            }
        }
    }
}


// MARK: Extensions
extension MemoListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MemoCell", for: indexPath) as? MemoListCell {
            let memo = memos[indexPath.row]
            cell.memo = memo
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let memoNum = memos[indexPath.row].id
            
            deleteMemoAlert(completion: { checkBtn in
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
    }
    
}

extension MemoListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
                            ACAMemoRequest().getMemoList(domain: domain, group: groupName, pageNum: pageNum, perPage: perPage) { memos in
                                if let memos = memos {
                                    self.memos += memos
                                }
                                self.pageNum += 1
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

