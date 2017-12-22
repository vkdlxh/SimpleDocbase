//
//  GroupListCell.swift
//  SimpleDocbase
//
//  Created by jeonsangjun on 2017/12/22.
//  Copyright © 2017年 archive-asia. All rights reserved.
//

import UIKit

class GroupListCell: UITableViewCell {

    var groupName: String? {
        didSet {
            guard let groupName = groupName else {
                return
            }
            groupLabel.text = groupName
        }
    }
    var iconName: String? {
        didSet {
            guard let iconName = iconName else {
                return
            }
            if let groupImage = UIImage(named: iconName) {
                let tintableImage = groupImage.withRenderingMode(.alwaysTemplate)
                iconImageView.image = tintableImage
                iconImageView.tintColor = ACAColor().ACAOrange
            }
        }
    }

    @IBOutlet weak var groupLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
