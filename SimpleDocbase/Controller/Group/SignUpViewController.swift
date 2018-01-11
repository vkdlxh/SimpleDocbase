//
//  SignUpViewController.swift
//  SimpleDocbase
//
//  Created by jeonsangjun on 2018/01/11.
//  Copyright © 2018年 archive-asia. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class SignUpViewController: UIViewController {
    
    // MARK: Properties
    var ref: DatabaseReference!
    
    // MARK: IBOutlets
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordCheckField: UITextField!
    @IBOutlet weak var apiToeknField: UITextField!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "アカウントを作成"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登録", style: .done, target: self,
            action: #selector(addTapped(sender:)))
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        ref = Database.database().reference()
    }
    
    // MARK: Private Methods
    @objc private func addTapped(sender: UIBarButtonItem) {
        self.view.endEditing(true)
        SVProgressHUD.show()
        //FIXME: フォムをチェックした後サインイン画面に遷移
        func getEmail(completion: @escaping (String) -> ()) {
            guard let email = emailField.text, !email.isEmpty else {
                self.signUpFailAlert("メールを記入してください。")
                return
            }
            if isValid(email) == false {
                self.signUpFailAlert("メールの形式で入力してください。")
            } else {
                completion(email)
            }
            
        }
        
        func getPassword(completion: @escaping (String) -> ()) {
            guard let password = passwordField.text, !password.isEmpty else {
                self.signUpFailAlert("パスワードを入力してください。")
                return
            }
            guard let passwordCheck = passwordCheckField.text, !passwordCheck.isEmpty else {
                self.signUpFailAlert("パスワードの確認を入力してください。")
                return
            }
            if password.count > 5 {
                if password == passwordCheck {
                    completion(password)
                } else {
                    self.signUpFailAlert("入力したパスワードが一致しません。")
                }
            } else {
                self.signUpFailAlert("パスワードは6文字以上で入力してください。")
            }
        }
        
        func getAPIToken(completion: @escaping (String) -> ()) {
            guard let apiToken = apiToeknField.text, !apiToken.isEmpty else {
                self.signUpFailAlert("APIトークンを記入してください。")
                return
            }
            completion(apiToken)
        }
        
        getEmail { email in
            getPassword { password in
                getAPIToken { apiToken in
                    Auth.auth().createUser(withEmail: email, password: password, completion: { user, error in
                        guard let user = user, error == nil else {
                            let errorCode = (error! as NSError).code
                            print(errorCode)
                            switch errorCode {
                            case 17007:
                                self.signUpFailAlert("もう登録されたメールです。")
                            default:
                                self.signUpFailAlert(error!.localizedDescription)
                            }
                            return
                        }
                        self.saveAPIToken(user, withUsername: apiToken)
                    })
                }
            }
        }
    }
    
    private func signUpFailAlert(_ messege: String) {
        SVProgressHUD.dismiss()
        let failAC = UIAlertController(title: messege, message: nil, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "確認", style: .cancel)
        failAC.addAction(okButton)
        present(failAC, animated: true, completion: nil)
    }
    
    // Saves user profile information to user database
    private func saveAPIToken(_ user: Firebase.User, withUsername apiToken: String) {
        
        // Create a change request
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        
        // Commit profile changes to server
        changeRequest?.commitChanges() { (error) in
            if let error = error {
                self.signUpFailAlert(error.localizedDescription)
                return
            }
            self.ref.child("users").child(user.uid).setValue(["apiToken": apiToken])
            //TODO: SUCCESS Alert and move to previous view
            SVProgressHUD.dismiss()
            let failAC = UIAlertController(title: "アカウントを作成しました。", message: nil, preferredStyle: .alert)
            let okButton = UIAlertAction(title: "確認", style: .cancel){ action in
                self.navigationController?.popViewController(animated: true)
            }
            failAC.addAction(okButton)
            self.present(failAC, animated: true, completion: nil)
            
        }
    }
    
    //
    private func isValid(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES[c] %@", emailRegEx)
        return emailTest.evaluate(with: email)
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
