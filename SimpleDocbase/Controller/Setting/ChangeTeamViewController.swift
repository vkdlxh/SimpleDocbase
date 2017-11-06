//
//  ChangeTeamViewController.swift
//  SimpleDocbase
//
//  Created by jeonsangjun on 2017/11/06.
//  Copyright © 2017年 jeon sangjun. All rights reserved.
//

import UIKit

class TeamListTableViewCell: UITableViewCell {
    
}

class ChangeTeamViewController: UIViewController {

    let request: Request = Request()
    var settingName: String = ""
    var teamNames = [String]()
    
    @IBOutlet weak var tableView: UITableView!
    
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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
        return cell
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
