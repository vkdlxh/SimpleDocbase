//
//  SettingItemViewController.swift
//  SimpleDocbase
//
//  Created by jeon sangjun on 2017/10/26.
//  Copyright © 2017年 jeon sangjun. All rights reserved.
//

import UIKit

class SettingItemViewController: UIViewController {

    // MARK: Properties
    var settingMenu: SettingMenu?
    
    // MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = settingMenu?.name
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
extension SettingItemViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let rowCount = settingMenu?.service?.count else { return 0 }
        return rowCount
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingItemCell", for: indexPath)
        
        guard let service = settingMenu?.service?[indexPath.row] else { return cell }
        
        cell.textLabel?.text = service.name
        return cell
    }
    
}
