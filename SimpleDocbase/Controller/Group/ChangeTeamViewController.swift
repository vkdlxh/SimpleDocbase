//
//  ChangeTeamViewController.swift
//  SimpleDocbase
//
//  Created by jeonsangjun on 2017/11/21.
//  Copyright © 2017年 archive-asia. All rights reserved.
//

import UIKit
import SVProgressHUD
import Firebase

class ChangeTeamViewController: UIViewController {
    
    // MARK: Properties
    var teams: [String] = []
    var beforeTeam = UserDefaults.standard.object(forKey: "selectedTeam") as? String
    var afertTeam: String?
    // MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "チーム変更"
        
        SVProgressHUD.show()

        ACATeamRequest().getTeamList { teams in
            if let teams = teams {
                self.teams = teams
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
                SVProgressHUD.dismiss()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkAccount()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if beforeTeam != afertTeam {
            UserDefaults.standard.removeObject(forKey: "selectedGroup")
        }
    }
    
    private func checkAccount() {
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

// MARK: Extensions
extension ChangeTeamViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "チーム一覧"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teams.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeamCell", for: indexPath)
        cell.textLabel?.text = teams[indexPath.row]
        
        let domain = UserDefaults.standard.object(forKey: "selectedTeam") as? String
        if cell.textLabel?.text == domain {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }

}

extension ChangeTeamViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedIndex = self.tableView.indexPathForSelectedRow?.row {
            UserDefaults.standard.set(teams[selectedIndex], forKey: "selectedTeam")
            afertTeam = UserDefaults.standard.object(forKey: "selectedTeam") as? String
            print("Team Changed \(teams[selectedIndex])")
            self.navigationController?.popViewController(animated: true)
        }
        
    }
}
