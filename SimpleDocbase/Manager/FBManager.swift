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
    
    func signOut(completion: @escaping (() -> ())) {
        let firebaseAuth = Auth.auth()
        let user = firebaseAuth.currentUser
        if (user?.uid) != nil {
            do {
                try firebaseAuth.signOut()
                apiToken = nil
                UserDefaults.standard.removeObject(forKey: "selectedTeam")
                UserDefaults.standard.removeObject(forKey: "selectedGroup")
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
            completion()
        }
    }
    
    func checkAccount(_ VC:UIViewController) {
        if testMode == false {
            if Auth.auth().currentUser == nil {
                let changedAccountAC = UIAlertController(title: "サインアウト", message: "サインアウトされました。", preferredStyle: .alert)
                let okButton = UIAlertAction(title: "確認", style: .default) { action in
                    VC.navigationController!.popToRootViewController(animated: true)
                }
                changedAccountAC.addAction(okButton)
                VC.present(changedAccountAC, animated: true, completion: nil)
            }
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
