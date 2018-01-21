
//
//  AccountViewController.swift
//  SimpleDocbase
//
//  Created by jeonsangjun on 2017/11/17.
//  Copyright © 2017年 archive-asia. All rights reserved.
//

import UIKit
import SwiftyFORM
import SVProgressHUD
import Firebase

class AccountViewController: FormViewController {

    enum AlertAction {
        case success
        case delete
    }

    // MARK: Properties
    let userDefaults = UserDefaults.standard
    var user = Auth.auth().currentUser
    var ref: DatabaseReference!

    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tokenKeySubmitButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        ref = Database.database().reference()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.popViewController(animated: true)
    }

    override func populate(_ builder: FormBuilder) {
        builder.navigationTitle = "アカウント情報"
        builder.toolbarMode = .simple
        builder += SectionHeaderTitleFormItem().title("情報")
        builder += email
        builder += SectionHeaderTitleFormItem().title("APIトークン修正")
        builder += tokenKey
        builder += SectionHeaderTitleFormItem()
        builder += signInButton
    }
    
    lazy var email: StaticTextFormItem = {
        let instance = StaticTextFormItem()
        instance.title = "メール"
        if let uid = user?.email {
            instance.value = uid
        } else {
            instance.value = "サインインしてください。"
        }
        return instance
    }()

    
    lazy var tokenKey: TextFieldFormItem = {
        let instance = TextFieldFormItem()
        instance.placeholder("APIトークンを入力してください。")
        if let tokenKey = userDefaults.object(forKey: "tokenKey") as? String{
            instance.value = tokenKey
        }
        return instance
    }()
    
    lazy var signInButton: ButtonFormItem = {
        let instance = ButtonFormItem()
        
        if let user = user {
            instance.title = "サインアウト"
            instance.action = {
                if (self.user?.uid) != nil {
                    let firebaseAuth = Auth.auth()
                    do {
                        try firebaseAuth.signOut()
                        UserDefaults.standard.removeObject(forKey: "tokenKey")
                        UserDefaults.standard.removeObject(forKey: "selectedTeam")
                        UserDefaults.standard.removeObject(forKey: "selectedGroup")
                    } catch let signOutError as NSError {
                        print ("Error signing out: %@", signOutError)
                    }
                    _ = self.navigationController?.popViewController(animated: true)
                }
            }
        } else {
            instance.title = "サインイン"
            instance.action = {
                self.tabBarController?.selectedIndex = 1
            }
        }
        
        return instance
    }()

    
    // MARK: Internal Methods
    
    // MARK: Private Methods
    private func tokenKeySubmitButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "修正", style: .plain, target: self, action: #selector(tokenKeySubmitAction))
    }
    
   @objc private func tokenKeySubmitAction() {
        if let user = user {
            if tokenKey.value.isEmpty {
                // TODO: Check TokenKey Delete Alert PopUp
                tokenKeyAlert(type: .delete)
            } else {
                // TODO: normally Regist TokenKey
                saveAPIToken(user, withUsername: tokenKey.value)
                userDefaults.removeObject(forKey: "selectedGroup")
                ACATeamRequest().getTeamList(completion: { teams in
                    self.userDefaults.set(teams?.first, forKey: "selectedTeam")
                })
                tokenKeyAlert(type: .success)
            }
        } else {
            let tokenAC = UIAlertController(title: nil, message: "サインインしてください。", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "確認", style: .default, handler: { action in
                self.tabBarController?.selectedIndex = 1
            })
            tokenAC.addAction(okAction)
            self.present(tokenAC, animated: true, completion: nil)
        }
    }
    
    private func saveAPIToken(_ user: Firebase.User, withUsername apiToken: String) {
        
        // Create a change request
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        
        // Commit profile changes to server
        changeRequest?.commitChanges() { (error) in
            if let error = error {
                print(error)
                return
            }
            self.ref.child("users").child(user.uid).setValue(["apiToken": apiToken])
            self.userDefaults.set(apiToken, forKey: "tokenKey")
            //TODO: SUCCESS Alert and move to previous view
            SVProgressHUD.dismiss()
            let failAC = UIAlertController(title: "アカウントを作成しました。", message: nil, preferredStyle: .alert)
            let okButton = UIAlertAction(title: "確認", style: .cancel){ action in
                let firebaseAuth = Auth.auth()
                do {
                    try firebaseAuth.signOut()
                } catch let signOutError as NSError {
                    print ("Error signing out: %@", signOutError)
                }
                self.navigationController?.popViewController(animated: true)
            }
            failAC.addAction(okButton)
            self.present(failAC, animated: true, completion: nil)
            
        }
    }
    
    private func tokenKeyAlert(type: AlertAction) {
        var alert = UIAlertController()
        switch type {
        case .success:
            alert = UIAlertController(title:"APIトークン登録", message: "APIトークンを登録しました。", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "確認", style: .default) { action in
                self.navigationController?.popViewController(animated: true)
            }
            alert.addAction(okButton)
        case .delete:
            alert = UIAlertController(title:"APIトークン削除", message: "APIトークンを削除しますか。", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "確認", style: .default) { action in
                self.userDefaults.removeObject(forKey: "tokenKey")
                self.userDefaults.removeObject(forKey: "selectedTeam")
                self.userDefaults.removeObject(forKey: "selectedGroup")
                self.navigationController?.popViewController(animated: true)
            }
            let cancelButton = UIAlertAction(title: "キャンセル", style: .cancel)
            
            alert.addAction(okButton)
            alert.addAction(cancelButton)
        }
        self.present(alert, animated: true, completion: nil)
    }

}
