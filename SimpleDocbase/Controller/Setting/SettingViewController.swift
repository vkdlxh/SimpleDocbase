//
//  SettingViewController.swift
//  SimpleDocbase
//
//  Created by jeon sangjun on 2017/10/25.
//  Copyright © 2017年 jeon sangjun. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
    
    // MARK: Properties
    var settingMenu = ["Token登録",
                       "勤怠管理グループ設定",
                       "所属チーム情報"]
    
    
    // MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
       if segue.identifier == "GoRegisterTokenKeySegue" {
            if let destination = segue.destination as? RegisterTokenKeyViewController {
                if let selectedIndex = self.tableView.indexPathForSelectedRow?.row {
                    destination.settingName = settingMenu[selectedIndex]
                }
            }
       } else if segue.identifier == "GoChangeTeamSegue" {
            if let destination = segue.destination as? ChangeTeamViewController {
                if let selectedIndex = self.tableView.indexPathForSelectedRow?.row {
                    destination.settingName = settingMenu[selectedIndex]
                }
            }
       } else if segue.identifier == "GoTeamInformSegue" {
            if let destination = segue.destination as? TeamInformViewController {
                if let selectedIndex = self.tableView.indexPathForSelectedRow?.row {
                    destination.settingName = settingMenu[selectedIndex]
                }
            }
        }
    }
}

// MARK: Extensions
extension SettingViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rowConut = settingMenu.count
        return rowConut
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath)
        
        let setting = settingMenu[indexPath.row]
        cell.textLabel?.text = setting
        return cell
    }
    
}

extension SettingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            performSegue(withIdentifier: "GoRegisterTokenKeySegue", sender: self)
            print("tapped indexPath.row: \(indexPath.row)")
        } else if indexPath.row == 1 {
            performSegue(withIdentifier: "GoChangeTeamSegue", sender: self)
            print("tapped indexPath.row: \(indexPath.row)")
        } else if indexPath.row == 2 {
            performSegue(withIdentifier: "GoTeamInformSegue", sender: self)
            print("tapped indexPath.row: \(indexPath.row)")
        }
    }
}


