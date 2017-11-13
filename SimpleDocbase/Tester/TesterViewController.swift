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
    var groups = [Group]()

    @IBOutlet weak var tableView: UITableView!
    
    
    @IBAction func getTeamBtn(_ sender: Any) {
        
        RequestClosure.singletonRequest.getTeamListClosure() { (teams: [String]) in
            self.teams = teams
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func getGroupBtn(_ sender: Any) {
        RequestClosure.singletonRequest.getGroupClosure() { (groups: [Group]) in
            self.groups = groups
            print(self.groups)
        }
    }
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let alert: UIAlertController = UIAlertController(title: "TokenKey設定", message: "TokenKeyを設定してください。", preferredStyle:  UIAlertControllerStyle.alert)

        if (UserDefaults.standard.object(forKey: "paramTokenKey") as? String) == nil || (UserDefaults.standard.object(forKey: "paramTokenKey") as? String) == "" {
            print("No TokenKey")
            let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
                (action: UIAlertAction!) -> Void in
                self.performSegue(withIdentifier: "GoSetTokenKey", sender: self)
                print("OK")
            })
            let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler:{                
                (action: UIAlertAction!) -> Void in
                print("Cancel")
            })
            
            alert.addAction(defaultAction)
            alert.addAction(cancelAction)
            
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }

        }
        
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
