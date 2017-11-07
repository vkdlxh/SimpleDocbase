//
//  DetailMemoViewController.swift
//  SimpleDocbase
//
//  Created by jeonsangjun on 2017/11/01.
//  Copyright © 2017年 jeon sangjun. All rights reserved.
//

import UIKit

class DetailMemoViewController: UIViewController {
    
    var memos = [Memo]()
    var groups = [Group]()
    
    // MARK: IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var groupLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var bodyTextView: UITextView!
    
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //FIXME: Memoで値も引き出す方法
    override func viewWillAppear(_ animated: Bool) {

        titleLabel.text = memos.first?.title
        bodyTextView.text = memos.first?.body
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
