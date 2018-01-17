///
//  GroupViewController.swift
//  SimpleDocbase
//
//  Created by jeon sangjun on 2017/10/25.
//  Copyright © 2017年 archive-asia. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import SwiftyFORM

class GroupViewController: UIViewController {
    
    // MARK: Properties
    var groups: [Group] = []
    var refreshControl: UIRefreshControl!
    let sectionTitle = ["チーム", "グループ一覧"]
    let fbManager = FBManager.sharedManager
    
    // MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageLabel: UILabel!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControlAction()
        tableView?.backgroundView = messageLabel
        self.tabBarController?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
        checkAccount()
        getGroupListFromRequest()

        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "サインアウト", style: .done, target: self, action: #selector(back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
        
        print("GroupViewController WillAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        SVProgressHUD.dismiss()
    }
    
    // MARK: Internal Methods
    
    // MARK: Private Methods
    @objc func back(sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            fbManager.apiToken = nil
            UserDefaults.standard.removeObject(forKey: "selectedTeam")
            UserDefaults.standard.removeObject(forKey: "selectedGroup")
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        _ = navigationController?.popViewController(animated: true)
    }
    
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

    private func getGroupListFromRequest() {
        SVProgressHUD.show(withStatus: "更新中")
        
        ACAGroupRequest().getGroupList { groups in
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
    
    private func checkAccount() {
        if fbManager.testMode == false {
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

