//
//  TesterTokenKeyViewController.swift
//  SimpleDocbase
//
//  Created by jeonsangjun on 2017/11/13.
//  Copyright © 2017年 archive-asia. All rights reserved.
//

import UIKit

class TesterTokenKeyViewController: UIViewController {
    @IBOutlet weak var tokenKeyTextField: UITextField!
    
    
    @IBAction func saveBtn(_ sender: Any) {

        let userDefaults = UserDefaults.standard
        userDefaults.set(tokenKeyTextField.text, forKey: "tokenKey")
        
        self.presentingViewController?.dismiss(animated: true, completion: nil)
        print("Setting Token Key : \(tokenKeyTextField.text!)")
    }
    
    @IBAction func cancelBtn(_ sender: Any) {
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
    


}
