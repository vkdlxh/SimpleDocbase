//
//  WorkSheetItemCell.swift
//  SimpleDocbase
//
//  Created by Lee jaeeun on 2017/11/14.
//  Copyright © 2017年 archive-asia. All rights reserved.
//

import UIKit

class WorkSheetItemCell: UITableViewCell {

    @IBOutlet var dayLabel: UILabel!
    @IBOutlet var weekLabel: UILabel!
    @IBOutlet var workDayButton: UIButton!    //toggle button
    @IBOutlet var beginTimeLabel: UILabel!
    @IBOutlet var endTimeLabel: UILabel!
    @IBOutlet var breakTimeLabel: UILabel!
    @IBOutlet var workTimeLabel: UILabel!
    @IBOutlet var remarkLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        breakTimeLabel.text = ""
        workTimeLabel.text = ""
        weekLabel.textColor = .black
    }
    
    internal func settingCell(_ sheetItem: WorkSheetItem) {
        
        if let workDay = sheetItem.workDay {
            dayLabel.text = String(format: "%d", workDay)
        }
        
        if let week = sheetItem.week {
            let weekString = Date.weekDayString(week:week)
            if weekString == "土" {
                weekLabel.textColor = .blue
            } else if weekString == "日" {
                weekLabel.textColor = .red
            }
            weekLabel.text = weekString
        }
        if let flag = sheetItem.workFlag {
            workDayButton?.setTitle(flag ? "◯" : "", for: .normal)
        }
        
        beginTimeLabel.text = sheetItem.beginTime?.hourMinuteString()
        endTimeLabel.text = sheetItem.endTime?.hourMinuteString()
        if let breakTime = sheetItem.breakTime {
            breakTimeLabel.text =  String(format: "%.1f", breakTime)
        }
        
        if let duration = sheetItem.duration {
            workTimeLabel.text = String(format: "%.1f", duration)
        }
        
        remarkLabel.text = sheetItem.remark
    }
    
}
