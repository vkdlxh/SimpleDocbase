//
//  WriteCommentCell.swift
//  SimpleDocbase
//
//  Created by jeonsangjun on 2017/12/22.
//  Copyright © 2017年 archive-asia. All rights reserved.
//

import UIKit

protocol WriteCommentCellDelegate {
    func successWriteComment()
    func failWriteComment()
}

class WriteCommentCell: UITableViewCell {

    // MARK: Properties
    var delegate: WriteCommentCellDelegate?
    var memoId = 0
    let domain = UserDefaults.standard.object(forKey: "selectedTeam") as! String

    //MARK: IBOutlet
    @IBOutlet weak var commentBodyTextView: UITextView!
    
    // MARK: IBAction
    @IBAction func writeCommentButton(_ sender: Any) {
        
        if let textField = commentBodyTextView.text, textField.isEmpty {
            delegate?.failWriteComment()
        } else {
            let comment: [String: Any] = ["body" : commentBodyTextView.text]
            self.commentBodyTextView.text = ""
            ACACommentRequest().writeComment(memoId: memoId, domain: domain, dict: comment) { bool in
                if bool == true {
                    DispatchQueue.main.async {
                        print("success write comment")
                        self.delegate?.successWriteComment()
                    }
                }
                
            }
        }
    }
    
    // MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        commentBodyTextView.layer.borderWidth = 1
        commentBodyTextView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.50).cgColor
        commentBodyTextView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.10)
        commentBodyTextView.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
