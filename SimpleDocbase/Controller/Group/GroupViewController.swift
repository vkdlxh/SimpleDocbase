//
//  GroupViewController.swift
//  SimpleDocbase
//
//  Created by jeon sangjun on 2017/10/25.
//  Copyright © 2017年 jeon sangjun. All rights reserved.
//

import UIKit

class GroupViewController: UIViewController {
    
    // MARK: Properties
    let request: Request = Request()
    var groups = [Group]()
    var refreshControl: UIRefreshControl!
    
    
    // MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // UIRefreshControl
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "引っ張って更新")
        self.refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.tableView.addSubview(refreshControl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        request.delegate = self
//        request.getTeamList()
        request.getGroupFromTeam()
        print("WilAppear")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MemoListSegue" {
            if let destination = segue.destination as? MemoListViewController {
                if let selectedIndex = self.tableView.indexPathForSelectedRow?.row {
                    destination.groupName = groups[selectedIndex].name
                }
            }
        }
    }
    
    
    @objc func refresh() {
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
}


// MARK: Extensions
extension GroupViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath)
        
        let groupName = groups[indexPath.row].name
        cell.textLabel?.text = groupName
        return cell
    }

}



//MARK: RequestDelegate
extension GroupViewController : RequestDelegate {
//    func didRecivedTeamList(teams: Array<String>) {
//        if let domain = UserDefaults.standard.object(forKey: "selectedDomain") as? String {
//              request.groupList(domain: domain)
//        } else {
//            if let domain = teams.first {
//                UserDefaults.standard.set(domain, forKey: "selectedDomain")
//                request.groupList(domain: domain)
//            }
//        }
//        print("didRecivedTeamList")
//    }
    
    func getGroupName(groups: Array<Any>) {
        if let paramGroup = groups as? [Group] {
            self.groups = paramGroup
        }
       
        DispatchQueue.main.async {
            self.tableView.reloadData()
            print("Main Queue")
        }
        print("getGroupName")
    }    
}
