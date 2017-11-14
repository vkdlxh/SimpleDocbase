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
        
        //week
        testDateExtension()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: Private
    private func testDateExtension() {
        
        let test_date = Date()
        
        print("firstDay: \(test_date.firstDay())");
        print("lastDay: \(test_date.lastDay())");
        print("weekDay: \(test_date.weekDay())");
        print("weekDayString: \(test_date.weekDayString())");
        print("isHoliday: \(test_date.isHoliday())");
        
        let end_date = test_date.addingTimeInterval(60*60*8)    // +8hour
        let work_time = Date.hourString(begin: test_date, end: end_date);
        print("workTime: \(work_time)")
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
