//
//  SignUpViewController.swift
//  SimpleDocbase
//
//  Created by jeonsangjun on 2018/01/11.
//  Copyright © 2018年 archive-asia. All rights reserved.
//

import UIKit
import SwiftyFORM
import Firebase
import SVProgressHUD

class SignUpViewController: FormViewController {
    
    // MARK: Properties
    var ref: DatabaseReference!
    let fbManager = FBManager.sharedManager
    let alertManager = AlertManager()
    let footerView = SectionFooterViewFormItem()
    let footerMessage = "\nDocBaseから\n「個人設定」→「基本設定」→「APIトークン」を\n作成して表示されたトークンを登録してください。"
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登録", style: .done, target: self,
                                                            action: #selector(addTapped(sender:)))
        AppUtility.lockOrientation(.portrait)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        ref = Database.database().reference()
    }

    override func populate(_ builder: FormBuilder) {
        configureFooterView()
        builder.navigationTitle = "アカウントを作成"
        builder.toolbarMode = .simple
        builder += SectionHeaderTitleFormItem().title("アカウント")
        builder += email
        builder += password
        builder += passwordCheck
        builder.alignLeft([email, password, passwordCheck])
        builder += SectionHeaderTitleFormItem().title("APIトークン")
        builder += apiToken
        builder += footerView
    }

    lazy var email: TextFieldFormItem = {
        let instance = TextFieldFormItem()
        instance.title("メール").placeholder("abc@example.com")
        instance.keyboardType = .emailAddress
        instance.softValidate(EmailSpecification(), message: "必ずメールの形式で入力してください。")
        return instance
        }()
    
    lazy var password: TextFieldFormItem = {
        let instance = TextFieldFormItem()
        instance.title("パスワード").password().placeholder("6文字以上で入力してください。")
        instance.keyboardType = .default
        instance.autocorrectionType = .no
        instance.submitValidate(CountSpecification.min(6), message: "パスワードは6文字以上で入力してください。")
        return instance
    }()
    
    lazy var passwordCheck: TextFieldFormItem = {
        let instance = TextFieldFormItem()
        instance.title("パスワード確認").password().placeholder("もう一回入力してください。")
        instance.keyboardType = .default
        instance.autocorrectionType = .no
        instance.submitValidate(CountSpecification.min(6), message: "パスワードは6文字以上で入力してください。")
        return instance
    }()

    
    lazy var apiToken: TextFieldFormItem = {
        let instance = TextFieldFormItem()
        instance.placeholder("有効なAPIトークンを入力してください。")
        instance.submitValidate(CountSpecification.min(1), message: "空欄なく入力してください。")
        return instance
    }()
    
    // MARK: Private Methods
    @objc private func addTapped(sender: UIBarButtonItem) {
        formBuilder.validateAndUpdateUI()
        self.view.endEditing(true)
        SVProgressHUD.show()
        //FIXME: フォムをチェックした後サインイン画面に遷移
        func getEmail(completion: @escaping (String) -> ()) {
            let emailValue = email.value
            if isValid(emailValue) == true {
                completion(emailValue)
            } else {
                SVProgressHUD.dismiss()
            }
        }

        func getPassword(completion: @escaping (String) -> ()) {
            let passwordValue = password.value
            let passwordCheckValue = passwordCheck.value
            if !passwordValue.isEmpty, !passwordCheckValue.isEmpty, passwordValue.count > 5 {
                if !(passwordValue == passwordCheckValue) {
                    SVProgressHUD.dismiss()
                    alertManager.confirmAlert(self, title: "入力したパスワードが一致しません。", message: nil) {
                    }
                } else {
                    completion(passwordValue)
                }
            } else {
                SVProgressHUD.dismiss()
            }
        }

        func getAPIToken(completion: @escaping (String) -> ()) {
            let apiTokenValue = apiToken.value
            if !apiTokenValue.isEmpty {
                completion(apiTokenValue)
            }
        }

        getEmail { email in
            getPassword { password in
                getAPIToken { apiToken in
                    Auth.auth().createUser(withEmail: email, password: password, completion: { user, error in
                        guard let user = user, error == nil else {
                            let errorCode = (error! as NSError).code
                            print(error)
                            switch errorCode {
                            case 17007:
                                SVProgressHUD.dismiss()
                                self.alertManager.confirmAlert(self, title: "もう登録されたメールです。", message: nil) {
                                }
                            default:
                                SVProgressHUD.dismiss()
                                self.alertManager.confirmAlert(self, title: error!.localizedDescription, message: nil) {
                                }
                            }
                            return
                        }
                        self.saveAPIToken(user, withUsername: apiToken)
                    })
                }
            }
        }
    }
    
    private func saveAPIToken(_ user: Firebase.User, withUsername apiToken: String) {
        
        // Create a change request
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        
        // Commit profile changes to server
        changeRequest?.commitChanges() { (error) in
            if let error = error {
                SVProgressHUD.dismiss()
                self.alertManager.confirmAlert(self, title: error.localizedDescription, message: nil) {
                }
                return
            }
            self.ref.child("users").child(user.uid).setValue(["apiToken": apiToken])
            //TODO: SUCCESS Alert and move to previous view
            SVProgressHUD.dismiss()
            self.alertManager.confirmAlert(self, title: "アカウントを作成しました。", message: nil) {
                self.fbManager.signOut {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    private func isValid(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES[c] %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }

    private func configureFooterView() {
        footerView.viewBlock = {
            return InfoView(frame: CGRect(x: 0, y: 0, width: 0, height: 100), text: self.footerMessage)
        }
    }

}
