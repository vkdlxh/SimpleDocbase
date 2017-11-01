//
//  MemoListViewController.swift
//  SimpleDocbase
//
//  Created by jeonsangjun on 2017/11/01.
//  Copyright © 2017年 jeon sangjun. All rights reserved.
//

import UIKit

class MemoListViewController: UIViewController {
    
    // MARK: Properties
    let request: Request = Request()
    var groupName: String = ""
    let domain = UserDefaults.standard.object(forKey: "selectedDomain") as? String
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        
        navigationItem.title = groupName
//        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
//                                                            target: self,
//                                                            action: #selector(addTapped(sender:)))
        
    }
    
    @objc func addTapped(sender: UIBarButtonItem) {
        
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

extension MemoListViewController: RequestDelegate {
//    func getMemoList(domain: String, group: String) {
//        <#code#>
//    }
}
