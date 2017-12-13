
//
//  RegisterTokenKeyViewController.swift
//  SimpleDocbase
//
//  Created by jeonsangjun on 2017/11/17.
//  Copyright © 2017年 archive-asia. All rights reserved.
//

import UIKit
import SwiftyFORM

class RegisterTokenKeyViewController: FormViewController {

    enum AlertAction {
        case success
        case delete
    }
    
    let userDefaults = UserDefaults.standard
    //8ZwKUqC7QkJJKZN2hP2i
    let footerView = SectionFooterViewFormItem()
    let footerMessage = "\nDocBaseから\n「個人設定」→「基本設定」→「APIトークン」を\n作成して表示されたトークンを登録してください。"

    override func viewDidLoad() {
        super.viewDidLoad()
        tokenKeySubmitButton()
    }

    override func populate(_ builder: FormBuilder) {
        configureFooterView()
        builder.navigationTitle = "トークン登録"
        builder.toolbarMode = .simple
        builder += SectionHeaderTitleFormItem().title("APIトークン登録")
        builder += tokenKey
        builder += footerView
    }
    
    lazy var tokenKey: TextFieldFormItem = {
        let instance = TextFieldFormItem()
        instance.placeholder("APIトークンを入力してください。")
        if let tokenKey = userDefaults.object(forKey: "paramTokenKey") as? String{
            instance.value = tokenKey
        }
        return instance
    }()
    
    private func tokenKeySubmitButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登録", style: .plain, target: self, action: #selector(tokenKeySubmitAction))
    }
    
   @objc private func tokenKeySubmitAction() {
        if tokenKey.value.isEmpty {
            // TODO: Check TokenKey Delete Alert PopUp
            tokenKeyAlert(type: .delete)
        } else {
            // TODO: normally Regist TokenKey
            userDefaults.set(tokenKey.value, forKey: "paramTokenKey")
            userDefaults.removeObject(forKey: "selectedTeam")
            userDefaults.removeObject(forKey: "selectedGroup")
            tokenKeyAlert(type: .success)
        }
    }
    
    private func tokenKeyAlert(type: AlertAction) {
        var alert = UIAlertController()
        switch type {
        case .success:
            alert = UIAlertController(title:"トークン登録", message: "トークンを登録しました。", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "確認", style: .default) { action in
                self.navigationController?.popViewController(animated: true)
            }
            alert.addAction(okButton)
        case .delete:
            alert = UIAlertController(title:"トークン削除", message: "トークンを削除しますか。", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "確認", style: .default) { action in
                self.userDefaults.removeObject(forKey: "paramTokenKey")
                self.userDefaults.removeObject(forKey: "selectedTeam")
                self.userDefaults.removeObject(forKey: "selectedGroup")
            }
            let cancelButton = UIAlertAction(title: "キャンセル", style: .cancel)
            
            alert.addAction(okButton)
            alert.addAction(cancelButton)
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    private func configureFooterView() {
        footerView.viewBlock = {
            return InfoView(frame: CGRect(x: 0, y: 0, width: 0, height: 80), text: self.footerMessage)
        }
    }

}
