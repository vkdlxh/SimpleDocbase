//
//  DaySheetHeaderView.swift
//  SimpleDocbase
//
//  Created by Lee jaeeun on 2017/11/17.
//  Copyright © 2017年 archive-asia. All rights reserved.
//

import UIKit

class DaySheetHeaderView: UIView {

    @IBOutlet var dayLabel: UILabel!
    @IBOutlet var weekLabel: UILabel!
    @IBOutlet var workDayLabel: UILabel!
    @IBOutlet var beginTimeLabel: UILabel!
    @IBOutlet var endTimeLabel: UILabel!
    @IBOutlet var breakTimeLabel: UILabel!
    @IBOutlet var workTimeLabel: UILabel!
    @IBOutlet var remarkLabel: UILabel!
    
    // MARK: Life cycle
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //
    }
    
    //Private
    private func setup() {
//        dayLabel.text       = "日"
//        weekLabel.text      = "曜日"
//        workDayLabel.text   = "作業日"
//        beginTimeLabel.text = "開始時間"
//        endTimeLabel.text   = "終了時間"
//        breakTimeLabel.text = "休憩"
//        workTimeLabel.text  = "勤務時間"
//        remarkLabel.text    = "備考"
        dayLabel.textColor = .lightGray
        weekLabel.textColor = .lightGray
        workDayLabel.textColor = .lightGray
        beginTimeLabel.textColor = .lightGray
        endTimeLabel.textColor = .lightGray
        breakTimeLabel.textColor = .lightGray
        workTimeLabel.textColor = .lightGray
        remarkLabel.textColor = .lightGray
    }
    
    
}
