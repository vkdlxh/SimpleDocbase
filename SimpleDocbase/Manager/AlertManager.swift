//
//  AlertManager.swift
//  SimpleDocbase
//
//  Created by jeonsangjun on 2018/01/18.
//  Copyright © 2018年 archive-asia. All rights reserved.
//

import UIKit

class AlertManager {
    
    func defaultAlert(_ vc: UIViewController, title: String, message: String?, btnName: String, completion: @escaping (() -> ())) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirmButton = UIAlertAction(title: btnName, style: .default) { action in
            completion()
            print("tapped \(btnName) Button")
        }
        let cancelButton = UIAlertAction(title: "キャンセル", style: .cancel) { action in
            print("tapped cancel Button")
        }
        
        alertController.addAction(confirmButton)
        alertController.addAction(cancelButton)
        vc.present(alertController, animated: true, completion: nil)
    }
    
    func confirmAlert(_ vc: UIViewController, title: String, message: String?, completion: @escaping (() -> ())) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirmButton = UIAlertAction(title: "確認", style: .cancel) { action in
            completion()
        }
        
        alertController.addAction(confirmButton)
        vc.present(alertController, animated: true, completion: nil)
    }
}
