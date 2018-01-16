//
//  FBManager.swift
//  SimpleDocbase
//
//  Created by jeonsangjun on 2018/01/16.
//  Copyright © 2018年 archive-asia. All rights reserved.
//

import UIKit
import Firebase

class FBManager {
    
    var remoteConfig: RemoteConfig!
    
    var apiToken: String?
    
    // testMode
    var testMode = false
    var testMail = ""
    var testPassword = ""
    var testToken = ""
    
    // Singleton
    static let sharedManager = FBManager()
    private init() {
       
    }
    
    func getPropertyFromRemoteConfig() {
        remoteConfig = RemoteConfig.remoteConfig()
        let remoteConfigSettings = RemoteConfigSettings(developerModeEnabled: true)
        remoteConfig.configSettings = remoteConfigSettings!
        remoteConfig.setDefaults(fromPlist: "GoogleService-Info")
        
        let expirationDuration = remoteConfig.configSettings.isDeveloperModeEnabled ? 0 : 3600
        
        remoteConfig.fetch(withExpirationDuration: TimeInterval(expirationDuration)){ (status, error) -> Void in
            if status == .success {
                print("Config fetched!")
                self.remoteConfig.activateFetched()
            } else {
                print("Config not fetched")
                print("Error: \(error?.localizedDescription ?? "No error available.")")
            }
            self.setProperty()
        }
    }
    
    private func setProperty() {
        let testModeConfigKey = "test_mode"
        let testMailConfigKey = "test_email"
        let testPasswordConfigKey = "test_password"
        let testTokenConfigKey = "test_token"
        
        testMode = remoteConfig[testModeConfigKey].boolValue
        if let testMail = remoteConfig[testMailConfigKey].stringValue {
            self.testMail = testMail
        }
        if let testPassword = remoteConfig[testPasswordConfigKey].stringValue {
            self.testPassword = testPassword
        }
        if let testToken = remoteConfig[testTokenConfigKey].stringValue {
            self.testToken = testToken
        }
    }
}
