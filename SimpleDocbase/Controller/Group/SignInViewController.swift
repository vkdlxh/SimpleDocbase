//
//  SignInViewController.swift
//  SimpleDocbase
//
//  Created by jeonsangjun on 2018/01/10.
//  Copyright © 2018年 archive-asia. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class SignInViewController: UIViewController {
    
    // MARK: Properties
    var ref: DatabaseReference!
    let userDefaults = UserDefaults.standard
//    var remoteConfig: RemoteConfig!
//    var testMode = false
//    var testMail = ""
//    var testPassword = ""
//    var testToken = ""

    // MARK: IBOutlets
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBAction func signInAction(_ sender: Any) {
        SVProgressHUD.show()
        guard let testMode = userDefaults.object(forKey: "testMode") as? Bool else {
            return
        }
        guard let testMail = userDefaults.object(forKey: "testMail") as? String else {
            return
        }
        guard let testPassword = userDefaults.object(forKey: "testPassword") as? String else {
            return
        }

        if let email = self.emailField.text, let password = self.passwordField.text {
            if testMode == true {
                // TEST Mode
                if testMail == email, testPassword == password{
//                    UserDefaults.standard.set(testToken, forKey: "tokenKey")
                    SVProgressHUD.dismiss()
                    emailField.text = ""
                    passwordField.text = ""
                    self.performSegue(withIdentifier: "SignInSegue", sender: self)
                } else {
                    signInFailAlert()
                }
            } else {
                // Nomal Mode
                Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                    if let error = error {
                        print(error)
                        self.signInFailAlert()
                        return
                    }
                    UserDefaults.standard.removeObject(forKey: "testMail")
                    SVProgressHUD.dismiss()
                    self.emailField.text = ""
                    self.passwordField.text = ""
                    self.performSegue(withIdentifier: "SignInSegue", sender: self)
                }
            }
        } else {
            //FIXME: メールとパスワードをチェックしてグループ画面に遷移するように
            signInFailAlert()
        }
        
    }
    
    @IBAction func SignUpAction(_ sender: Any) {
        self.performSegue(withIdentifier: "SignUpSegue", sender: self)
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "SignInSegue", sender: nil)
        }
        ref = Database.database().reference()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: Private Methods
    private func signInFailAlert() {
        SVProgressHUD.dismiss()
        let failAC = UIAlertController(title: "メール/パスワードを\n確認してください。", message: nil, preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: "確認", style: .cancel)
        failAC.addAction(cancelButton)
        present(failAC, animated: true, completion: nil)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "SignInSegue" {
//            if let destination = segue.destination as? GroupViewController {
//                destination.testMode = testMode
//            }
//        }
//    }
    

}
