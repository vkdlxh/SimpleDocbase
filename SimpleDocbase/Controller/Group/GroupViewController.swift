//
//  GroupViewController.swift
//  SimpleDocbase
//
//  Created by jeon sangjun on 2017/10/25.
//  Copyright © 2017年 jeon sangjun. All rights reserved.
//

import UIKit
import SVProgressHUD

class GroupViewController: UIViewController {
    
    // MARK: Properties
    let request: GroupRequest = GroupRequest()
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
        
        // Tokenkey Check Alert
        let alert: UIAlertController = UIAlertController(title: "TokenKey設定", message: "TokenKeyを設定してください。", preferredStyle:  UIAlertControllerStyle.alert)
        
        if (UserDefaults.standard.object(forKey: "paramTokenKey") as? String) == nil || (UserDefaults.standard.object(forKey: "paramTokenKey") as? String) == "" {
            print("No TokenKey")
            
            let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
                (action: UIAlertAction!) -> Void in
                //FIXME: refreshができない
                let storyboard = UIStoryboard(name: "Setting", bundle: nil)
                if let tokenKeyViewController = storyboard.instantiateViewController(withIdentifier: "SetTokenkeyViewController") as? UINavigationController {
                    if let targetViewController = tokenKeyViewController.topViewController as? SetTokenkeyViewController {
                        targetViewController.delegate = self
                        self.present(tokenKeyViewController, animated: true, completion: nil)
                    }
                }
                
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
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        SVProgressHUD.show()
        request.delegate = self
        request.getGroupFromTeam()
        print("GroupViewController WillAppear")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoMemoListSegue" {
            if let destination = segue.destination as? MemoListViewController {
                if let selectedIndex = self.tableView.indexPathForSelectedRow?.row {
                    destination.groupName = groups[selectedIndex].name
                }
            }
        }
    }
    
    @objc func refresh() {
        request.getGroupFromTeam()
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
extension GroupViewController : RequestDelegate, SetTokenkeyViewControllerDelegate {
    
    func didRecivedGroup(groups: Array<Any>) {
        print("didRecivedGroup(groups: )")
        if let paramGroup = groups as? [Group] {
            self.groups = paramGroup
        }
       
        DispatchQueue.main.async {
            self.tableView.reloadData()
            print("GroupViewController reloadData()")
            self.refreshControl.endRefreshing()
            SVProgressHUD.dismiss()
        }
    }
    
    func sendTokenKey() {
        
        dismiss(animated: true, completion: nil)
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
            print("sendTokenKey Reload")
        }
        
    }
}
