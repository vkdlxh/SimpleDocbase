//
//  SFSettingViewController.swift
//  SimpleDocbase
//
//  Created by jeonsangjun on 2017/11/17.
//  Copyright © 2017年 archive-asia. All rights reserved.
//

import UIKit
import SwiftyFORM

class SFSettingViewController: FormViewController {
    
    let userDefaults = UserDefaults.standard

    override func populate(_ builder: FormBuilder) {
        builder.navigationTitle = "設定"
        builder += SectionHeaderTitleFormItem().title("OPTION")
        builder += ViewControllerFormItem().title("Token登録").placeholder(userDefaults.object(forKey: "paramTokenKey") as! String).viewController(SFRegisterTokenKeyViewController.self)
        builder += ViewControllerFormItem().title("勤怠管理グループ設定").viewController(SFChangeTeamViewController.self)
        builder += ViewControllerFormItem().title("所属チーム情報").viewController(SFTeamInfomationViewController.self)
    }

}
