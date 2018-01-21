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

    // MARK: IBOutlets
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBAction func signInAction(_ sender: Any) {
        SVProgressHUD.show()
        if let email = self.emailField.text, let password = self.passwordField.text {
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                if let error = error {
                    print(error)
                    self.signInFailAlert()
                    return
                }
                let userID = Auth.auth().currentUser?.uid
                self.ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
                    // Get user value
                    let value = snapshot.value as? NSDictionary
                    let apiToken = value?["apiToken"] as? String ?? ""
                    UserDefaults.standard.set(apiToken, forKey: "tokenKey")
//                    ACARequest().tokenKey = apiToken
                    DispatchQueue.main.async {
                        SVProgressHUD.dismiss()
                        self.performSegue(withIdentifier: "SignInSegue", sender: self)
                    }
                }) { (error) in
                    print(error.localizedDescription)
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
    

}
