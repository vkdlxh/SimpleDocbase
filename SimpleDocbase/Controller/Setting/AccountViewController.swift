
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
    
    // MARK: Properties
    let userDefaults = UserDefaults.standard
    let fbManager = FBManager.sharedManager
    let alertManager = AlertManager()
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
        if fbManager.statsOfSignIn == true {
            if let uid = user?.email {
                instance.value = uid
            }
        } else {
            instance.value = "サインインしてください。"
        }
        return instance
    }()

    
    lazy var tokenKey: TextFieldFormItem = {
        let instance = TextFieldFormItem()
        instance.placeholder("APIトークンを入力してください。")
        if let apiToken = fbManager.apiToken {
            instance.value = apiToken
        }
        return instance
    }()
    
    lazy var signInButton: ButtonFormItem = {
        let instance = ButtonFormItem()
        if fbManager.statsOfSignIn == true {
            if let user = user {
                instance.title = "サインアウト"
                instance.action = {
                    self.fbManager.signOut {
                        _ = self.navigationController?.popViewController(animated: true)
                    }
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
        self.view.endEditing(true)
        if fbManager.statsOfSignIn == true {
            if let user = user {
                if tokenKey.value.isEmpty {
                    // TODO: Check TokenKey Delete Alert PopUp
                    alertManager.defaultAlert(self, title: "APIトークン削除", message: "APIトークンを削除しますか。", btnName: "削除") {
                        self.userDefaults.removeObject(forKey: "selectedTeam")
                        self.userDefaults.removeObject(forKey: "selectedGroup")
                        self.navigationController?.popViewController(animated: true)
                    }
                } else {
                    // TODO: normally Regist TokenKey
                    saveAPIToken(user, withUsername: tokenKey.value)
                    userDefaults.removeObject(forKey: "selectedGroup")
                    ACATeamRequest().getTeamList(completion: { teams in
                        self.userDefaults.set(teams?.first, forKey: "selectedTeam")
                    })
                    alertManager.confirmAlert(self, title: "APIトークン登録", message: "APIトークンを登録しました。") {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        } else {
            alertManager.confirmAlert(self, title: "サインインしてください。", message: nil) {
                self.tabBarController?.selectedIndex = 1
            }
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
            self.fbManager.apiToken = apiToken
        }
    }

}
