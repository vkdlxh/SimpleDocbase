//
//  DetailMemoViewController.swift
//  SimpleDocbase
//
//  Created by jeonsangjun on 2017/11/01.
//  Copyright © 2017年 archive-asia. All rights reserved.
//

import UIKit

class DetailMemoViewController: UIViewController {
    
    // MARK: Properties
    var memo: Memo?
    var groups = [Group]()
    
    // MARK: IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var groupLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var bodyTextView: UITextView!
    
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        if let memo = self.memo {
            titleLabel.text = memo.title
            bodyTextView.text = memo.body
        }
    }

}
