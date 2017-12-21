//
//  GroupListCell.swift
//  SimpleDocbase
//
//  Created by jeonsangjun on 2017/12/21.
//  Copyright © 2017年 archive-asia. All rights reserved.
//

import UIKit

class GroupListCell: UITableViewCell {

    @IBOutlet weak var groupView: UIView!
    @IBOutlet weak var groupLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        groupView.layer.borderWidth = 1
        groupView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.50).cgColor
        groupView.layer.cornerRadius = 5
        
    }
    
//    override func prepareForReuse() {
//        groupView.backgroundColor = .white
//    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
