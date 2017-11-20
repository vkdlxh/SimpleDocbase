//
//  DetailMemoViewController.swift
//  SimpleDocbase
//
//  Created by jeonsangjun on 2017/11/01.
//  Copyright © 2017年 archive-asia. All rights reserved.
//

import UIKit
import SwiftyMarkdown

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
            bodyTextView.attributedText = SwiftyMarkdown(string: memo.body).attributedString()
            
            var groups: [String] = []
            for i in 0..<memo.groups.count{
                groups.append(memo.groups[i].name)
            }
            groupLabel.text = groups.joined(separator: ", ")
            
            var tags: [String] = []
            for i in 0..<memo.tags.count{
                tags.append(memo.tags[i].name)
            }
            tagLabel.text = tags.joined(separator: ", ")
            
        }
    }

}
