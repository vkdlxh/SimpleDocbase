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
    @IBOutlet var remainTimeLabel: UILabel! //総営業時間（契約時間）-勤務時間
    
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
        
        yearMonthLabel.text = workSheet.workdate.yearMonthString()
        workDaySumLabel.text = "\(workSheet.workDaySum) Days"
        workTimeSumLabel.text = "\(workSheet.workTimeSum) Hours"
        
        //TODO: 設定から指定した時間もしくは営業時間を計算したものにする。かりで１６０にした。
        remainTimeLabel.text = "\(160-workSheet.workTimeSum) Remains"
    }

}
