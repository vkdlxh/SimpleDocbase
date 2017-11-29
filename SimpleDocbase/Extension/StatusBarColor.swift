//
//  StatusBarColor.swift
//  SimpleDocbase
//
//  Created by jeonsangjun on 2017/11/27.
//  Copyright © 2017年 archive-asia. All rights reserved.
//

import UIKit

extension UIApplication {
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}
