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
import SwiftyFORM

class SignInViewController: UIViewController {
    
    // MARK: Properties
    var ref: DatabaseReference!
    let userDefaults = UserDefaults.standard
    let fbManager = FBManager.sharedManager
    let alertManager = AlertManager()

    // MARK: IBOutlets
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var passwordImageView: UIImageView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBAction func signInAction(_ sender: Any) {
        SVProgressHUD.show()
        print(fbManager.testMode)
        if let email = self.emailField.text, let password = self.passwordField.text {
            if fbManager.testMode == true {
                // TEST Mode
                if fbManager.testMail == email, fbManager.testPassword == password {
                    SVProgressHUD.dismiss()
                    emailField.text = ""
                    passwordField.text = ""
                    self.performSegue(withIdentifier: "SignInSegue", sender: self)
                } else {
                    Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                        if let error = error {
                            print(error)
                            SVProgressHUD.dismiss()
                            self.alertManager.confirmAlert(self, title: "メール/パスワードを\n確認してください。", message: nil) {
                            }
                            return
                        }
                        self.setAPIToken()
                    }
                }
            } else {
                // Nomal Mode
                Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                    if let error = error {
                        print(error)
                        SVProgressHUD.dismiss()
                        self.alertManager.confirmAlert(self, title: "メール/パスワードを\n確認してください。", message: nil) {
                        }
                        return
                    }
                    self.setAPIToken()
                }
            }
        } else {
            SVProgressHUD.dismiss()
            alertManager.confirmAlert(self, title: "メール/パスワードを\n確認してください。", message: nil) {
            }
        }
        
    }
    
    @IBAction func SignUpAction(_ sender: Any) {
        self.performSegue(withIdentifier: "SignUpSegue", sender: self)
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if let userImage = UIImage(named: "User") {
            let tintableImage = userImage.withRenderingMode(.alwaysTemplate)
            userImageView.image = tintableImage
            userImageView.tintColor = ACAColor().ACAOrange
        }
        if let passwordImage = UIImage(named: "Password") {
            let tintableImage = passwordImage.withRenderingMode(.alwaysTemplate)
            passwordImageView.image = tintableImage
            passwordImageView.tintColor = ACAColor().ACAOrange
        }
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        AppUtility.lockOrientation(.portrait)
        self.navigationController?.isNavigationBarHidden = true
        ref = Database.database().reference()
        if Auth.auth().currentUser != nil {
            SVProgressHUD.show(withStatus: "自動サインイン中")
            setAPIToken()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.view.endEditing(true)
        AppUtility.lockOrientation(.all)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: Private Methods
    @objc private func keyboardWillShow(_ notification: Notification) {
        let userInfo = (notification as NSNotification).userInfo!
        let keyboardHeight =  (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        logoImageView.isHidden = true
        bottomConstraint.constant = keyboardHeight.height
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        logoImageView.isHidden = false
        bottomConstraint.constant = 0
    }
    
    func setAPIToken() {
        let userID = Auth.auth().currentUser?.uid
        self.ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let apiToken = value?["apiToken"] as? String ?? ""
            self.fbManager.apiToken = apiToken
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                self.emailField.text = ""
                self.passwordField.text = ""
                self.performSegue(withIdentifier: "SignInSegue", sender: self)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }

}
