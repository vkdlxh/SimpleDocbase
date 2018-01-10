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
    let sectionTitle = ["チーム", "グループ一覧"]
    
    // MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageLabel: UILabel!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControlAction()
//        checkTokenKeyAlert()
        tableView?.backgroundView = messageLabel
        
        self.tabBarController?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getGroupListFromRequest()
        
        print("GroupViewController WillAppear")
    }
    
    // MARK: Internal Methods
    
    // MARK: Private Methods
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
    
//    private func checkTokenKeyAlert() {
//        let ac = UIAlertController(title: "APIトークン設定", message: "APIトークンを設定してください。", preferredStyle: .alert)
//
//        ac.addTextField { (textfield) in
//            textfield.placeholder = "APIトークン入力。。。"
//        }
//
//        let tokenKey = UserDefaults.standard.object(forKey: "tokenKey") as? String
//        if tokenKey == nil {
//            print("No TokenKey")
//
//            let submitAction = UIAlertAction(title: "APIトークン登録", style: .default) { _ in
//                guard let tokenKey = ac.textFields?[0].text else {
//                    return
//                }
//                if tokenKey.isEmpty {
//                    self.checkTokenKeyAlert()
//                    print("トークン登録失敗")
//                } else {
//                    UserDefaults.standard.set(tokenKey, forKey: "tokenKey")
//                    self.getGroupListFromRequest()
//                }
//            }
//
//            let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: .cancel) {
//                (action: UIAlertAction!) -> Void in
//                print("Cancel")
//            }
//
//            ac.addAction(submitAction)
//            ac.addAction(cancelAction)
//
//            DispatchQueue.main.async {
//                SVProgressHUD.dismiss()
//                self.present(ac, animated: true, completion: nil)
//            }
//        }
//    }
    
    private func getGroupListFromRequest() {
        SVProgressHUD.show(withStatus: "更新中")
        DispatchQueue.global().async {
            ACAGroupRequest.init().getGroupList { groups in
                if let groups = groups {
                    self.groups = groups
                } else {
                    SVProgressHUD.showError(withStatus: "エラー")
                    SVProgressHUD.dismiss(withDelay: 1)
                    self.groups.removeAll()
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    SVProgressHUD.dismiss()
                }
            }
        }
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
            messageLabel?.isHidden = false
            return 0
        } else {
            messageLabel?.isHidden = true
            return sectionTitle.count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return sectionTitle[0]
        case 1:
            return sectionTitle[1]
        default:
            return ""
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
        if let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as? GroupListCell {
            switch indexPath.section {
            case 0:
                if let team = UserDefaults.standard.object(forKey: "selectedTeam") as? String {
                    cell.groupName = team
                    cell.iconName = "Team"
                    return cell
                }
            case 1:
                cell.groupName = groups[indexPath.row].name
                cell.iconName = "People"
                return cell
            default:
                break
            }
        }
        return UITableViewCell()
    }
    
}

extension GroupViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            self.performSegue(withIdentifier: "GoChangeTeam", sender: nil)
        } else if indexPath.section == 1 {
            self.performSegue(withIdentifier: "GoMemoListSegue", sender: nil)
        }
        tableView.deselectRow(at: indexPath, animated: true)
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

