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
    var ref: DatabaseReference!
//    var ref = Database.database().reference()

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBAction func signInAction(_ sender: Any) {
        if let email = self.emailField.text, let password = self.passwordField.text {
            // [START headless_email_auth]
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                // [START_EXCLUDE]
                if let error = error {
                    print(error)
                    self.signInFailAlert()
                    return
                }
                
                self.performSegue(withIdentifier: "SignInSegue", sender: self)
                // [END_EXCLUDE]
            }
            // [END headless_email_auth]
        } else {
            //FIXME: メールとパスワードをチェックしてグループ画面に遷移するように
            signInFailAlert()
        }
    }
    
    @IBAction func SignUpAction(_ sender: Any) {
        self.performSegue(withIdentifier: "SignUpSegue", sender: self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SignInSegue" {
            let backItem = UIBarButtonItem()
            backItem.title = "サインアウト"
            navigationItem.backBarButtonItem = backItem
        }
    }
    
    private func signInFailAlert() {
        let failAC = UIAlertController(title: "メール/パスワードを\n確認してください。", message: nil, preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: "確認", style: .cancel)
        failAC.addAction(cancelButton)
        present(failAC, animated: true, completion: nil)
    }
    

}
