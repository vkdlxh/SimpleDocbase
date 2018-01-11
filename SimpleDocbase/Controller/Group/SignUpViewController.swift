//
//  SignUpViewController.swift
//  SimpleDocbase
//
//  Created by jeonsangjun on 2018/01/11.
//  Copyright © 2018年 archive-asia. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordCheckField: UITextField!
    @IBOutlet weak var apiToeknField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "アカウントを作成"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登録", style: .done, target: self,
            action: #selector(addTapped(sender:)))
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc private func addTapped(sender: UIBarButtonItem) {
        //FIXME: フォムをチェックした後サインイン画面に遷移

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
