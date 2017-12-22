//
//  ChangeTeamViewController.swift
//  SimpleDocbase
//
//  Created by jeonsangjun on 2017/11/21.
//  Copyright © 2017年 archive-asia. All rights reserved.
//

import UIKit
import SVProgressHUD

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
    
    override func viewWillDisappear(_ animated: Bool) {
        if beforeTeam != afertTeam {
            UserDefaults.standard.removeObject(forKey: "selectedGroup")
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let headerLabel = UILabel(frame: CGRect(x: 20, y: 10, width:
            tableView.bounds.size.width, height: tableView.bounds.size.height))
        headerLabel.textColor = .lightGray
        headerLabel.font = UIFont.systemFont(ofSize: 14)
        headerLabel.text = self.tableView(self.tableView, titleForHeaderInSection: section)
        headerLabel.sizeToFit()
        headerView.addSubview(headerLabel)
        
        return headerView
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
