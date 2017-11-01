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
    var groupNames = [String]()
    
    // MARK: IBActions
    @IBAction func testButton(_ sender: Any) {
        
        request.delegate = self
        
        request.getTeamList()
        
    }
    
    // UIRefreshControl
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
extension GroupViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let rowConut = groupNames.count
        return rowConut
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath)
        
//        let groupName = groupNames[indexPath.row]
//        cell.textLabel?.text = groupName
        return cell
    }
}

//MARK: RequestDelegate
extension GroupViewController : RequestDelegate {
    func didRecivedTeamList(teams: Array<String>) {

        print(teams)
    }
    
    func getGroupName(groups: Array<String>) {
        self.groupNames = groups
    }
    
}
