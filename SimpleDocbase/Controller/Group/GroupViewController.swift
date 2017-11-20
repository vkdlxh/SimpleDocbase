//
//  GroupViewController.swift
//  SimpleDocbase
//
//  Created by jeon sangjun on 2017/10/25.
//  Copyright © 2017年 archive-asia. All rights reserved.
//

import UIKit
import SVProgressHUD

class GroupViewController: UIViewController {
    
    // MARK: Properties
    var groups = [Group]()
    var refreshControl: UIRefreshControl!
    
    
    // MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControlAction()
        checkTokenKeyAlert()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        SVProgressHUD.show()
        ACAGroupRequest.init().getGroupList { groups in
            if let groups = groups {
                self.groups = groups
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
                SVProgressHUD.dismiss()
            }
        }
        
        print("GroupViewController WillAppear")
    }
    
    // MARK: Internal Methods
    @objc func refresh() {
        ACAGroupRequest.init().getGroupList { groups in
            if let groups = groups {
                self.groups = groups
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    func refreshControlAction() {
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "引っ張って更新")
        self.refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.tableView.addSubview(refreshControl)
    }
    
    func checkTokenKeyAlert() {
        let ac = UIAlertController(title: "TokenKey設定", message: "TokenKeyを設定してください。", preferredStyle: .alert)
        ac.addTextField()
        
        if (UserDefaults.standard.object(forKey: "paramTokenKey") as? String) == nil || (UserDefaults.standard.object(forKey: "paramTokenKey") as? String) == "" {
            print("No TokenKey")
            
            let submitAction = UIAlertAction(title: "TokenKey登録", style: .default) { [unowned ac] _ in
                if let tokenKey = ac.textFields?[0].text {
                    UserDefaults.standard.set(tokenKey, forKey: "paramTokenKey")
                    self.tableView.reloadData()
                }
            }
            
            let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: .cancel) {
                (action: UIAlertAction!) -> Void in
                print("Cancel")
            }
            
            ac.addAction(submitAction)
            ac.addAction(cancelAction)
            
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                self.present(ac, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoMemoListSegue" {
            if let destination = segue.destination as? MemoListViewController {
                if let selectedIndex = self.tableView.indexPathForSelectedRow?.row {
                    destination.groupName = groups[selectedIndex].name
                }
            }
        }
    }
    
}


// MARK: Extensions
extension GroupViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath)
        
        let groupName = groups[indexPath.row].name
        cell.textLabel?.text = groupName
        return cell
    }

}

