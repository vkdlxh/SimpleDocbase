///
//  GroupViewController.swift
//  SimpleDocbase
//
//  Created by jeon sangjun on 2017/10/25.
//  Copyright © 2017年 archive-asia. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftyFORM

class GroupViewController: UIViewController {
    
    // MARK: Properties
    var groups: [Group] = []
    var refreshControl: UIRefreshControl!
    let sectionTitle = ["チーム変更", "グループリスト"]
    
    // MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageLabel: UILabel!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControlAction()
        checkTokenKeyAlert()
        tableView?.backgroundView = messageLabel
        
        self.tabBarController?.delegate = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        SVProgressHUD.show(withStatus: "更新中")
        getGroupListFromRequest()
        
        print("GroupViewController WillAppear")
    }
    
    // MARK: Internal Methods
    @objc private func refresh() {
        ACAGroupRequest().getGroupList { groups in
            if let groups = groups {
                self.groups = groups
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    private func refreshControlAction() {
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "引っ張って更新")
        self.refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.tableView.addSubview(refreshControl)
    }
    
    private func checkTokenKeyAlert() {
        let ac = UIAlertController(title: "APIトークン設定", message: "APIトークンを設定してください。", preferredStyle: .alert)
        
        //test code.
        //ac.addTextField()
        ac.addTextField { (textfield) in
            textfield.text = "8ZwKUqC7QkJJKZN2hP2i"
        }
        
        let tokenKey = UserDefaults.standard.object(forKey: "tokenKey") as? String
        if tokenKey == nil {
            print("No TokenKey")
            
            let submitAction = UIAlertAction(title: "APIトークン登録", style: .default) { [unowned ac] _ in
                if let tokenKey = ac.textFields?[0].text {
                    UserDefaults.standard.set(tokenKey, forKey: "tokenKey")
                }
                self.getGroupListFromRequest()
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
    
    private func getGroupListFromRequest() {
        DispatchQueue.global().async {
            ACAGroupRequest.init().getGroupList { groups in
                if let groups = groups {
                    self.groups = groups
                }
                DispatchQueue.main.async {
                    if groups == nil {
                        SVProgressHUD.showError(withStatus: "エラー")
                        SVProgressHUD.dismiss(withDelay: 1)
                        self.groups.removeAll()
                    } else {
                        SVProgressHUD.dismiss()
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    private func emptyMessage(_ on: Bool) {
        messageLabel?.isHidden = !on
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoMemoListSegue" {
            if let destination = segue.destination as? MemoListViewController {
                if let selectedIndex = self.tableView.indexPathForSelectedRow?.row {
                    destination.group = groups[selectedIndex]
                }
            }
        }
    }
    
}


// MARK: Extensions
extension GroupViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if groups.count == 0 {
              emptyMessage(true)
            return 0
        } else {
            return sectionTitle.count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let dummyViewHeight = CGFloat(40)
        self.tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: dummyViewHeight))
        self.tableView.contentInset = UIEdgeInsetsMake(-dummyViewHeight, 0, 0, 0)
        return sectionTitle[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        emptyMessage(groups.count == 0)
        switch section {
        case 0:
            return 1
        case 1:
            return groups.count
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath)
        
        switch indexPath.section {
        case 0:
            if let team = UserDefaults.standard.object(forKey: "selectedTeam") as? String {
                cell.textLabel?.text = team
            }
        case 1:
            cell.textLabel?.text = groups[indexPath.row].name
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let headerLabel = UILabel(frame: CGRect(x: 20, y: 10, width:
            tableView.bounds.size.width, height: tableView.bounds.size.height))
        headerLabel.textColor = .lightGray
        headerLabel.text = self.tableView(self.tableView, titleForHeaderInSection: section)
        headerLabel.sizeToFit()
        headerView.addSubview(headerLabel)
        
        return headerView
    }
    
}

extension GroupViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            self.performSegue(withIdentifier: "GoChangeTeam", sender: nil)
        } else if indexPath.section == 1 {
            self.performSegue(withIdentifier: "GoMemoListSegue", sender: nil)
        }
    }
}

extension GroupViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        if let navController = self.tabBarController?.viewControllers?[2] as? UINavigationController {
            if let settingVC = navController.childViewControllers.first as? SettingViewController {
                settingVC.groups = groups
            }
        }
        
        return true
    }

}

