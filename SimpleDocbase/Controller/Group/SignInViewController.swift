//
//  SignInViewController.swift
//  SimpleDocbase
//
//  Created by jeonsangjun on 2018/01/10.
//  Copyright © 2018年 archive-asia. All rights reserved.
//

import UIKit
import Firebase

class SignInViewController: UIViewController {

    
    @IBAction func signInAction(_ sender: Any) {
        
        //FIXME: メールとパスワードをチェックしてグループ画面に遷移するように
        performSegue(withIdentifier: "SignInSegue", sender: self)
        
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SignInSegue" {
            let backItem = UIBarButtonItem()
            backItem.title = "サインアウト"
            navigationItem.backBarButtonItem = backItem
        }
//        else if segue.identifier == "GoWriteMemoSegue" {
//            if let destination = segue.destination as? UINavigationController {
//                if let tagetController = destination.topViewController as? WriteMemoViewController {
//                    tagetController.delegate = self
//                    tagetController.group = self.group
//                }
//            }
//        }
    }
    

}
