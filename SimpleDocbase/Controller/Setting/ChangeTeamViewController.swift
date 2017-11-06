//
//  ChangeTeamViewController.swift
//  SimpleDocbase
//
//  Created by jeonsangjun on 2017/11/06.
//  Copyright © 2017年 jeon sangjun. All rights reserved.
//

import UIKit

class ChangeTeamViewController: UIViewController {

    // MARK: Properties
    let request: Request = Request()
    var settingName: String = ""
    var teamNames = [String]()
    let userDefaults = UserDefaults.standard
    
    // MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = settingName
    }
    
    override func viewWillAppear(_ animated: Bool) {
        request.delegate = self
        request.getTeamList()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// MARK: Extensions
extension ChangeTeamViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teamNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeamCell", for: indexPath)
        
        let teamName = teamNames[indexPath.row]
        cell.textLabel?.text = teamName
        
        let domain = userDefaults.object(forKey: "selectedDomain") as? String
        if cell.textLabel?.text == domain {
            cell.backgroundColor = UIColor.blue
            cell.textLabel?.textColor = UIColor.white
        } else {
            cell.backgroundColor = UIColor.clear
            cell.textLabel?.textColor = UIColor.black
        }
        
        return cell
    }
}

extension ChangeTeamViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedIndex = self.tableView.indexPathForSelectedRow?.row {
            userDefaults.set(teamNames[selectedIndex], forKey: "selectedDomain")
            print("Team Changed \(teamNames[selectedIndex])")
            self.tableView.reloadData()
        }
    }
}

extension ChangeTeamViewController: RequestDelegate {
    func didRecivedTeamList(teams: Array<String>) {
        teamNames = teams
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
