//
//  WorkSheet.swift
//  SimpleDocbase
//
//  Created by Lee jaeeun on 2017/11/10.
//  Copyright © 2017年 archive-asia. All rights reserved.
//

import Foundation

//enum WeekDay: Int {
//    case Sun
//    case Mon
//    case Tue
//    case Wed
//    case Thu
//    case Fri
//    case Sat
//}

struct WorkSheet {
    var workdate: Date
    var workTimeSum: Double
    var workDaySum: Int
    var items = [WorkSheetItem]()
    
    init(date: Date) {
        self.workdate = date
        self.workTimeSum = 0
        self.workDaySum = 0
    }
}

struct WorkSheetItem {
    var workYear: Int      /// yyyy
    var workMonth: Int     /// mm
    var workDay: Int       /// dd
    var workFlag: Bool?
    var week: Int?
    var beginTime: Date?
    var endTime: Date?
    var breakTime: Double?
    var duration: Double?
    var remark: String?
    
    
    init(year: Int, month: Int, day: Int) {
        self.workYear = year
        self.workMonth = month
        self.workDay = day
        
        if let workDate = Date.createDate(year: year, month: month, day: day) {
            self.week = workDate.weekDay()
            self.workFlag = !workDate.isHoliday()
        }
    }
    
}
