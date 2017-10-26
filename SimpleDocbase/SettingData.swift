//
//  SettingData.swift
//  SimpleDocbase
//
//  Created by jeon sangjun on 2017/10/25.
//  Copyright © 2017年 jeon sangjun. All rights reserved.
//

import Foundation

let settingData: SettingData = SettingData()

class SettingData {
    
    var settings: [SettingMenu] = []
    
    init() {
        let tokenRegistration = SettingMenu(name: "Token登録")
        let commuteGroupSetting = SettingMenu(name: "勤怠管理グループ設定")
        let timeInfomation = SettingMenu(name: "所属チーム情報")
    
    settings += [tokenRegistration, commuteGroupSetting, timeInfomation]
    }
        
}
