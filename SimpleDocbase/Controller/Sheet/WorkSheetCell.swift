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
    
    //MARK: Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
            workDaySumLabel.text = "\(workDaySum) Days"
        }
        
        if let workTimeSum = workSheet.workTimeSum {
            workTimeSumLabel.text = "\(workTimeSum) Hours"
        }
    }

}
