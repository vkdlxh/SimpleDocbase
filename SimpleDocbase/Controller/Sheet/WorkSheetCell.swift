//
//  WorkSheetCell.swift
//  SimpleDocbase
//
//  Created by jaeeun on 2017/11/12.
//  Copyright © 2017年 archive-asia. All rights reserved.
//

import UIKit

class WorkSheetCell: UITableViewCell {

    //MARK: Properties
    
    //MARK: IBOutlet
    @IBOutlet var yearMonthLabel: UILabel!
    @IBOutlet var workDaySumLabel: UILabel!
    @IBOutlet var workTimeSumLabel: UILabel!
    @IBOutlet weak var workSheetView: UIView!
    
    //MARK: Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        workSheetView.layer.borderWidth = 1
        workSheetView.layer.borderColor = ACAColor().ACALightGrayColor.cgColor
        workSheetView.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: Internal
    internal func settingCell(_ workSheet: WorkSheet) {
        
        if let workYearMonth = workSheet.workdate?.yearMonthString() {
            yearMonthLabel.text = workYearMonth
        }
        
        if let workDaySum = workSheet.workDaySum {
            workDaySumLabel.text = "\(workDaySum)"
        }
        
        if let workTimeSum = workSheet.workTimeSum {
            workTimeSumLabel.text = "\(workTimeSum)"
        }
    }

}
