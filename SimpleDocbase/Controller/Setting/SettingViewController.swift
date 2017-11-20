//
//  SettingViewController.swift
//  SimpleDocbase
//
//  Created by jeonsangjun on 2017/11/17.
//  Copyright © 2017年 archive-asia. All rights reserved.
//

import UIKit
import SwiftyFORM

class SettingViewController: FormViewController {
    
    let userDefaults = UserDefaults.standard

    override func populate(_ builder: FormBuilder) {
        builder.navigationTitle = "設定"
        builder += SectionHeaderTitleFormItem().title("OPTION")
        builder += ViewControllerFormItem().title("Token登録").viewController(RegisterTokenKeyViewController.self)
        builder += groupListPiker
        builder += ViewControllerFormItem().title("所属チーム情報").viewController(TeamInfomationViewController.self)
        builder += SectionHeaderTitleFormItem().title("APP INFO")
        builder += StaticTextFormItem().title("Version").value(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String)
       
    }
    
    lazy var groupListPiker: OptionPickerFormItem = {
        let instance = OptionPickerFormItem()
        instance.title("勤怠管理グループ設定")
        ACAGroupRequest.init().getGroupClosure { groupList in
            if let groupList = groupList {
                for group in groupList {
                    instance.append(group.name)
                }
            }
        }
        if let selectedGroup = userDefaults.object(forKey: "SelectedGroup") as? String {
            instance.placeholder(selectedGroup)
        }
        instance.valueDidChange = { (selected: OptionRowModel?) in
            print("adopt bitcoin: \(String(describing: selected))")
            self.userDefaults.set(selected?.title, forKey: "SelectedGroup")
        }
        return instance
    }()

}
