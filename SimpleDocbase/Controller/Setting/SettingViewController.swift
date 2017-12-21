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
    var groups = [Group]()
    var preTeam = ""
    var preTokenKey = ""

    override func populate(_ builder: FormBuilder) {
        builder.navigationTitle = "設定"
        builder += SectionHeaderTitleFormItem().title("APIトークン登録")
        builder += tokenKeyViewControllerForm
        
        builder += SectionHeaderTitleFormItem().title("勤怠管理設定")
        builder += groupListPiker
        builder += minuteIntervalSetting
        
        builder += SectionHeaderTitleFormItem().title("チーム情報")
        builder += teamNameTextForm
        
        builder += SectionHeaderTitleFormItem().title("アプリ情報")
        builder += StaticTextFormItem().title("Version").value(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String)
        updateForm()
       
    }
    
    override func viewDidLoad() {
        if let preTokenKey = userDefaults.object(forKey: "paramTokenKey") as? String {
            self.preTokenKey = preTokenKey
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateForm()
//        updateGroupPicker(groupListPiker)
        reloadForm()
    }
    
    lazy var tokenKeyViewControllerForm: ViewControllerFormItem = {
        return ViewControllerFormItem().viewController(RegisterTokenKeyViewController.self)
    }()
    
    
    lazy var teamNameTextForm: StaticTextFormItem = {
        if let selectedTeam = userDefaults.object(forKey: "selectedTeam") as? String {
            preTeam = selectedTeam
        }
        return StaticTextFormItem().title("所属チーム情報")
    }()
    
    lazy var groupListPiker: OptionPickerFormItem = {
        let instance = OptionPickerFormItem()
        instance.title("勤怠管理グループ設定")
        
        instance.append("未登録")
        for group in groups {
            instance.append(group.name)
        }
        
        if let selectedGroup = userDefaults.object(forKey: "selectedGroup") as? String {
            let selectedOption = instance.options.filter{ $0.title == selectedGroup }.first
            if let selectedOption = selectedOption {
                instance.setSelectedOptionRow(selectedOption)
            }
        } else {
            instance.selectOptionWithTitle("未登録")
        }
        
        instance.valueDidChange = { (selected: OptionRowModel?) in
            self.userDefaults.set(selected?.title, forKey: "selectedGroup")
        }
        
        return instance
    }()
    
    lazy var minuteIntervalSetting: SegmentedControlFormItem = {
        let instance = SegmentedControlFormItem()
        instance.title = "勤務時間設定"
        instance.items = ["15","30"]
        
        if let minuteInterval = userDefaults.object(forKey: "minuteInterval") as? String {
            if let selectedItemIndex = instance.items.index(where: { $0 == minuteInterval }) {
                instance.selected = selectedItemIndex
            }
        } else {
            // Default Interval = 30 min
            userDefaults.set("30", forKey: "minuteInterval")
            instance.selected = 1
        }
        instance.valueDidChangeBlock = { [weak self] _ in
            self?.updateIntervalTime()
        }
        
        return instance
    }()
    
    private func updateForm() {
        
        if let tokenKey = userDefaults.object(forKey: "paramTokenKey") as? String {
            tokenKeyViewControllerForm.title("\(tokenKey)")
            
            if preTokenKey != tokenKey {
                DispatchQueue.global().async {
                    
                    ACAGroupRequest.init().getGroupList { groups in
                        DispatchQueue.main.async {
                            if let groups = groups {
                                self.groupListPiker.options.removeAll()
                                self.groupListPiker.append("未登録")
                                for group in groups {
                                    self.groupListPiker.append(group.name)
                                }
                            }
                        }
                    }
                }
                self.preTokenKey = tokenKey
            } else {
                updateGroupPicker(groupListPiker)
            }
            
        } else {
            tokenKeyViewControllerForm.title = "APIトークンを登録してください。"
            preTokenKey = ""
            groups.removeAll()
            updateGroupPicker(groupListPiker)
        }
        
        if let selectedTeam = userDefaults.object(forKey: "selectedTeam") as? String {
            teamNameTextForm.value = "\(selectedTeam)"
        } else {
            teamNameTextForm.value.removeAll()
        }
    }
    
    private func updateGroupPicker(_ picker: OptionPickerFormItem) {
        let currentTeam = userDefaults.object(forKey: "selectedTeam") as? String
        
        if let currentTeam = currentTeam {
            if preTeam != currentTeam {
                picker.selected = nil
                userDefaults.set(nil, forKey: "selectedGroup")
                preTeam = currentTeam
            }
            picker.options.removeAll()
            picker.append("未登録")
            for group in groups {
                picker.append(group.name)
            }
            if let selectedGroup = userDefaults.object(forKey: "selectedGroup") as? String {
                let selectedOption = picker.options.filter{ $0.title == selectedGroup }.first
                if let selectedOption = selectedOption {
                    picker.setSelectedOptionRow(selectedOption)
                }
            } else {
                picker.selectOptionWithTitle("未登録")
            }
        } else {
            picker.options.removeAll()
            picker.append("未登録")
            picker.selectOptionWithTitle("未登録")
        }
    }
    
    private func updateIntervalTime() {
        userDefaults.set(minuteIntervalSetting.selectedItem, forKey: "minuteInterval")
        print("Changed IntervalTime \(String(describing: minuteIntervalSetting.selectedItem))")
    }
 
}
