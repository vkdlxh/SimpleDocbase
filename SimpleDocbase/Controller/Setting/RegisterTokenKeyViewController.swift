//
//  RegisterTokenKeyViewController.swift
//  SimpleDocbase
//
//  Created by jeon sangjun on 2017/10/26.
//  Copyright © 2017年 jeon sangjun. All rights reserved.
//

import UIKit

class RegisterTokenKeyViewController: UIViewController {

    // MARK: Properties
    var settingName: String = ""
    
    // MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var resultTokenKey: UILabel!

    @IBAction func setTokenKeyButton(_ sender: Any) {
        performSegue(withIdentifier: "SetTokenKeySegue", sender: self)
    }
    
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = settingName
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let userDefaults = UserDefaults.standard
        
        if let tokenKey = userDefaults.object(forKey: "paramTokenKey") as? String {
            resultTokenKey.text = tokenKey
        }
    }
}

// MARK: Extensions
extension RegisterTokenKeyViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingItemCell", for: indexPath)
        
        return cell
    }
    
}
