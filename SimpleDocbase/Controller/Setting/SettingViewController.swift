//
//  SettingViewController.swift
//  SimpleDocbase
//
//  Created by jeonsangjun on 2017/11/17.
//  Copyright © 2017年 archive-asia. All rights reserved.
//

import UIKit
import SwiftyFORM
import Firebase

class SettingViewController: FormViewController {
    
    // MARK: Properties
    let userDefaults = UserDefaults.standard
    var groups = [Group]()
    var preTeam = ""
    let fbManaber = FBManager.sharedManager

    // MARK: Lifecycle
    override func populate(_ builder: FormBuilder) {
        builder.navigationTitle = "設定"
        if fbManaber.testMode == false {
            builder += SectionHeaderTitleFormItem().title("アカウント")
            builder += accountViewControllerForm
        }

        builder += SectionHeaderTitleFormItem().title("勤怠管理設定")
        builder += groupListPiker
        builder += minuteIntervalSetting
        
        builder += SectionHeaderTitleFormItem().title("チーム情報")
        builder += teamNameTextForm
        
        builder += SectionHeaderTitleFormItem().title("アプリ情報")
        builder += StaticTextFormItem().title("Version").value(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String)
        updateForm()
       
    }

    override func viewWillAppear(_ animated: Bool) {
        updateForm()
        reloadForm()
    }
    
    lazy var accountViewControllerForm: ViewControllerFormItem = {
        let instance = ViewControllerFormItem()
        instance.title = "アカウント設定"
        instance.viewController(AccountViewController.self)
        return instance
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
    
    // MARK: Internal Methods
    
    // MARK: Private Methods
    private func updateForm() {
        
        if let selectedTeam = userDefaults.object(forKey: "selectedTeam") as? String {
            teamNameTextForm.value = "\(selectedTeam)"
        } else {
            teamNameTextForm.value.removeAll()
        }
        
        updateGroupPicker(groupListPiker)
    }
    
    private func updateGroupPicker(_ picker: OptionPickerFormItem) {
        picker.options.removeAll()
        picker.append("未登録")
        picker.selectOptionWithTitle("未登録")
        if let currentTeam = userDefaults.object(forKey: "selectedTeam") as? String {
            if preTeam != currentTeam {
                picker.selected = nil
                userDefaults.removeObject(forKey: "selectedGroup")
                preTeam = currentTeam
            }
            for group in groups {
                picker.append(group.name)
            }
            if let selectedGroup = userDefaults.object(forKey: "selectedGroup") as? String {
                let selectedOption = picker.options.filter{ $0.title == selectedGroup }.first
                if let selectedOption = selectedOption {
                    picker.setSelectedOptionRow(selectedOption)
                }
            }
        }
    }
    
    private func updateIntervalTime() {
        userDefaults.set(minuteIntervalSetting.selectedItem, forKey: "minuteInterval")
        print("Changed IntervalTime \(String(describing: minuteIntervalSetting.selectedItem))")
    }
 
}
