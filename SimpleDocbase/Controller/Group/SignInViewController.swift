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
    let fbManager = FBManager.sharedManager

    // MARK: IBOutlets
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var passwordImageView: UIImageView!
    @IBOutlet weak var logoImageView: UIImageView!
    
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
                    self.setAPIToken()
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
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        ref = Database.database().reference()
        if Auth.auth().currentUser != nil {
            SVProgressHUD.show(withStatus: "自動サインイン中")
            setAPIToken()
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape {
            print("Landscape")
            logoImageView.isHidden = true
        } else {
            print("Portrait")
            logoImageView.isHidden = false
            
        }
    }
    
    // MARK: Private Methods
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
    
    private func signInFailAlert() {
        SVProgressHUD.dismiss()
        let failAC = UIAlertController(title: "メール/パスワードを\n確認してください。", message: nil, preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: "確認", style: .cancel)
        failAC.addAction(cancelButton)
        present(failAC, animated: true, completion: nil)
    }

}
