//
//  TesterViewController.swift
//  SimpleDocbase
//
//  Created by jeonsangjun on 2017/11/10.
//  Copyright © 2017年 archive-asia. All rights reserved.
//

import UIKit

class TesterViewController: UIViewController {

    var teams = [String]()

    @IBOutlet weak var tableView: UITableView!
    
    
    @IBAction func getTeamBtn(_ sender: Any) {
        
        RequestClosure.singletonRequest.getTeamListClosure() { (groups: [String]) in
            self.teams = groups
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// MARK: Extensions
extension TesterViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return teams.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeamCell", for: indexPath)
        
        let team = teams[indexPath.row]
        cell.textLabel?.text = team
        return cell
    }
    
}
