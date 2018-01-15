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
    var remoteConfig: RemoteConfig!
    var testMode = false
    var testMail = ""
    var testPassword = ""
    var testToken = ""

    // MARK: IBOutlets
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBAction func signInAction(_ sender: Any) {
        SVProgressHUD.show()

        if let email = self.emailField.text, let password = self.passwordField.text {
            if testMode == true {
                // TEST Mode
                if testMail == email, testPassword == password{
                    UserDefaults.standard.set(testToken, forKey: "tokenKey")
                    UserDefaults.standard.set(email, forKey: "testMail")
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
                    let userID = Auth.auth().currentUser?.uid
                    self.ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
                        // Get user value
                        let value = snapshot.value as? NSDictionary
                        let apiToken = value?["apiToken"] as? String ?? ""
                        UserDefaults.standard.set(apiToken, forKey: "tokenKey")
                        //                    ACARequest().tokenKey = apiToken
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
        UserDefaults.standard.removeObject(forKey: "testMail")
        remoteConfig = RemoteConfig.remoteConfig()
        let remoteConfigSettings = RemoteConfigSettings(developerModeEnabled: true)
        remoteConfig.configSettings = remoteConfigSettings!
        remoteConfig.setDefaults(fromPlist: "GoogleService-Info")
        
        fetchConfig()
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
    
    func fetchConfig() {
        let expirationDuration = remoteConfig.configSettings.isDeveloperModeEnabled ? 0 : 3600
        
        remoteConfig.fetch(withExpirationDuration: TimeInterval(expirationDuration)){ (status, error) -> Void in
            if status == .success {
                print("Config fetched!")
                self.remoteConfig.activateFetched()
            } else {
                print("Config not fetched")
                print("Error: \(error?.localizedDescription ?? "No error available.")")
            }
            
            self.getTestAccountFromRemoteConfig()
        }
    }
    
    func getTestAccountFromRemoteConfig() {
        let testModeConfigKey = "test_mode"
        let testMailConfigKey = "test_email"
        let testPasswordConfigKey = "test_password"
        let testTokenConfigKey = "test_token"
        
        testMode = remoteConfig[testModeConfigKey].boolValue
        if let testMail = remoteConfig[testMailConfigKey].stringValue {
            self.testMail = testMail
        }
        if let testPassword = remoteConfig[testPasswordConfigKey].stringValue {
            self.testPassword = testPassword
        }
        if let testToken = remoteConfig[testTokenConfigKey].stringValue {
            self.testToken = testToken
        }
    }
    
    // MARK: Private Methods
    private func signInFailAlert() {
        SVProgressHUD.dismiss()
        let failAC = UIAlertController(title: "メール/パスワードを\n確認してください。", message: nil, preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: "確認", style: .cancel)
        failAC.addAction(cancelButton)
        present(failAC, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SignInSegue" {
            if let destination = segue.destination as? GroupViewController {
                destination.testMode = testMode
            }
        }
    }
    

}
