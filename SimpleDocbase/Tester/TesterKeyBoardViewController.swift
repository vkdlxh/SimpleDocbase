//
//  TesterKeyBoardViewController.swift
//  SimpleDocbase
//
//  Created by jeonsangjun on 2017/12/22.
//  Copyright © 2017年 archive-asia. All rights reserved.
//

import UIKit

class TesterKeyBoardViewController: UIViewController {

    let messageInputContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(messageInputContainer)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: [], metrics: nil, views: ["view":messageInputContainer]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view(48)]|", options: [], metrics: nil, views: ["view":messageInputContainer]))
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
