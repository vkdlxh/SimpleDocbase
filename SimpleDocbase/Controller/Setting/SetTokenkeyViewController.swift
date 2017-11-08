//
//  SetTokenkeyViewController.swift
//  SimpleDocbase
//
//  Created by jeonsangjun on 2017/10/31.
//  Copyright © 2017年 jeon sangjun. All rights reserved.
//

import UIKit

class SetTokenkeyViewController: UIViewController {

    var settingName = ""

    @IBOutlet weak var paramTokenKey: UITextField!
    
    @IBAction func saveButton(_ sender: Any) {
        
        let userDefaults = UserDefaults.standard
        userDefaults.set(paramTokenKey.text, forKey: "paramTokenKey")
        
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backButton = UIBarButtonItem()
        navigationItem.backBarButtonItem = backButton
    }
 

}
