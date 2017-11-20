
//
//  SFRegisterTokenKeyViewController.swift
//  SimpleDocbase
//
//  Created by jeonsangjun on 2017/11/17.
//  Copyright © 2017年 archive-asia. All rights reserved.
//

import UIKit
import SwiftyFORM

class SFRegisterTokenKeyViewController: FormViewController {

    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tokenKeySubmitButton()
    }

    override func populate(_ builder: FormBuilder) {
        builder.navigationTitle = "Token登録"
        builder.toolbarMode = .simple
        builder += tokenKey
    }
    
    lazy var tokenKey: TextFieldFormItem = {
        let instance = TextFieldFormItem()
        instance.title("TokenKey").placeholder("ここにTokenKeyの入力")
        instance.submitValidate(CountSpecification.min(1), message: "正しい値を入力してください。")
        return instance
    }()
    
    func tokenKeySubmitButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .plain, target: self, action: #selector(tokenKeySubmitAction(_:)))
    }
    
    @objc public func tokenKeySubmitAction(_ sender: AnyObject?) {
        formBuilder.validateAndUpdateUI()
        let result = formBuilder.validate()
        print("result \(result)")
        tokenKey_showSubmitResult(result)
    }
    
    func tokenKey_showSubmitResult(_ result: FormBuilder.FormValidateResult) {
        switch result {
        case .valid:
            let userDefaults = UserDefaults.standard
            userDefaults.set(tokenKey.value, forKey: "paramTokenKey")
            success_simpleAlert("登録", "Tokenを登録しました。")
        case let .invalid(item, message):
            let title = item.elementIdentifier ?? "失敗"
            fail_simpleAlert(title, message)
        }
    }

}
