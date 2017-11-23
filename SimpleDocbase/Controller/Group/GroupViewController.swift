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
    var groups: [Group] = []
    var refreshControl: UIRefreshControl!
    
    let sectionTitle = ["チーム変更", "グループリスト"]
    
    
    // MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControlAction()
        checkTokenKeyAlert()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        SVProgressHUD.show(withStatus: "更新中")
        self.getGroupListFromRequest()
        
        print("GroupViewController WillAppear")
    }
    
    // MARK: Internal Methods
    @objc func refresh() {
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
    
    func refreshControlAction() {
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "引っ張って更新")
        self.refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.tableView.addSubview(refreshControl)
    }
    
    func checkTokenKeyAlert() {
        let ac = UIAlertController(title: "TokenKey設定", message: "TokenKeyを設定してください。", preferredStyle: .alert)
        
        //test code.
        //ac.addTextField()
        ac.addTextField { (textfield) in
            textfield.text = "8ZwKUqC7QkJJKZN2hP2i"
        }
        
        if (UserDefaults.standard.object(forKey: "paramTokenKey") as? String) == nil || (UserDefaults.standard.object(forKey: "paramTokenKey") as? String) == "" {
            print("No TokenKey")
            
            let submitAction = UIAlertAction(title: "TokenKey登録", style: .default) { [unowned ac] _ in
                if let tokenKey = ac.textFields?[0].text {
                    UserDefaults.standard.set(tokenKey, forKey: "paramTokenKey")
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
    
    func getGroupListFromRequest() {
        DispatchQueue.global().async {
            ACAGroupRequest.init().getGroupList { groups in
                if let groups = groups {
                    self.groups = groups
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    if groups == nil {
                        SVProgressHUD.showError(withStatus: "ERROR")
                        SVProgressHUD.dismiss(withDelay: 1)
                    } else {
                        SVProgressHUD.dismiss()
                    }
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
                    destination.groupName = groups[selectedIndex].name
                }
            }
        }
    }
    
}


// MARK: Extensions
extension GroupViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if groups.count == 0 {
            return 0
        } else {
            return sectionTitle.count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitle[section]
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath)
        
        switch indexPath.section {
        case 0:
            if let team = UserDefaults.standard.object(forKey: "selectedTeam") as? String {
                cell.textLabel?.text = team
                cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 20)
                cell.textLabel?.textColor = ACAColor().ACADarkRed
            }
        case 1:
            cell.textLabel?.text = groups[indexPath.row].name
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 20)
            cell.textLabel?.textColor = ACAColor().ACADarkRed
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let headerLabel = UILabel(frame: CGRect(x: 20, y: 10, width:
            tableView.bounds.size.width, height: tableView.bounds.size.height))
        headerLabel.textColor = ACAColor().ACADeepPink
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

