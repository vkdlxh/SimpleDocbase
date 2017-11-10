//
//  TeamInformViewController.swift
//  SimpleDocbase
//
//  Created by jeonsangjun on 2017/11/06.
//  Copyright © 2017年 jeon sangjun. All rights reserved.
//

import UIKit

class TeamInformViewController: UIViewController {
    
    var settingName: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = settingName
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
