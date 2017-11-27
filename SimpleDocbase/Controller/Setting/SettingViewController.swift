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
        builder += tokenKeyViewControllerForm
        builder += groupListPiker
        builder += teamNameTextForm
        builder += SectionHeaderTitleFormItem().title("APP INFO")
        builder += StaticTextFormItem().title("Version").value(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String)
        updateForm()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateForm()
    }

    lazy var tokenKeyViewControllerForm: ViewControllerFormItem = {
        return ViewControllerFormItem().title("Token登録").viewController(RegisterTokenKeyViewController.self)
    }()
    
    lazy var teamNameTextForm: StaticTextFormItem = {
        return StaticTextFormItem().title("所属チーム情報")
    }()
    
    func updateForm() {
        if let tokenKey = userDefaults.object(forKey: "paramTokenKey") as? String {
            tokenKeyViewControllerForm.placeholder = "\(tokenKey)"
        } else {
            tokenKeyViewControllerForm.placeholder = "None"
        }
        
        
        if let selectedTeam = userDefaults.object(forKey: "selectedTeam") as? String {
            teamNameTextForm.value = "\(selectedTeam)"
        } else {
            teamNameTextForm.value = "None"
        }
        
    }
    
    lazy var groupListPiker: OptionPickerFormItem = {
        let instance = OptionPickerFormItem()
        instance.title("勤怠管理グループ設定")
        ACAGroupRequest().getGroupList { groupList in
            if let groupList = groupList {
                DispatchQueue.main.async {
                    for group in groupList {
                        instance.append(group.name)
                    }
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
