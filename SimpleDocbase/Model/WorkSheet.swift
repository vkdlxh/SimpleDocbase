//
//  WorkSheet.swift
//  SimpleDocbase
//
//  Created by Lee jaeeun on 2017/11/10.
//  Copyright © 2017年 archive-asia. All rights reserved.
//

import Foundation

struct WorkSheet {
    var title: String
    var totalWorkTime: Double?
    var totalWorkDay: Int?
    var items = [WorkSheetItem]()
    
    init(title: String) {
        self.title = title
        self.totalWorkTime = 0
        self.totalWorkDay = 0
    }
}

struct WorkSheetItem {
    var workYear: String      /// yyyy
    var workMonth: String     /// mm
    var workDay: String       /// dd
    var week: Int
    var beginTime: Date?
    var endTime: Date?
    var duration: Double?
    var remark: String?
    var dayOff: Bool
    var breakTime: Double?
    
    init(year: String, month: String, day: String) {
        self.workYear = year
        self.workMonth = month
        self.workDay = day
        self.week = 1
        self.dayOff = false
    }
    
}
