//
//  GroupViewController.swift
//  SimpleDocbase
//
//  Created by jeon sangjun on 2017/10/25.
//  Copyright © 2017年 jeon sangjun. All rights reserved.
//

import UIKit

class GroupViewController: UITableViewController {

    
    // MARK: Properties
    let request: Request = Request()
    
    
    @IBAction func testButton(_ sender: Any) {
        
        request.delegate = self
        
        request.getTeamList()
        
    }
    
    // UIRefreshControl
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //FIXME: viewDidLoad()が呼ばれるとき、基本のチームのdomain(配列の0番目の値)を貰えたいです。
        if request.teamDomain == nil {
            
            // 関数を呼び出してteamDomainsの配列を作ってdefaultDomainを作る用です。
            request.delegate = self
            
            request.getTeamList()
            
            
            if let defaultDomain = request.teamDomains.first {
                request.groupList(domain: defaultDomain)
            }
            
        } else {
            
            //FIXME: 後で設定でチームを選択してから選択されたチームのdomainを持ってGroupList()に入れて選択されたチームのGroupリストを見せる。
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//MARK: RequestDelegate
extension GroupViewController : RequestDelegate {
    
    func didRecivedTeamList(teams: Array<String>) {

        print(teams)
    }
    
}
