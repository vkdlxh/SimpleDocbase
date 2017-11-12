//
//  Date+WorkSheet.swift
//  SimpleDocbase
//
//  Created by jaeeun on 2017/11/11.
//  Copyright © 2017年 archive-asia. All rights reserved.
//

import UIKit

/*
 *　参考リンク
 * https://qiita.com/isom0242/items/e83ab77a3f56f66edd2f
 */

extension Date  {
    
    func defaultCalendar() -> Calendar {
        var calendar = Calendar.current
        //calendar.locale = Locale(identifier: "ja_JP")
        //calendar.timeZone = TimeZone(identifier: "Asia/Tokyo")!
        
        return calendar
    }
    
    func firstDay() -> Int {
        let calendar = defaultCalendar()
        // 月初
        let comps = calendar.dateComponents([.year, .month], from: self)
        let firstDate = calendar.date(from: comps)
        let day = calendar.component(.day, from: firstDate!)
        return day
    }
    
    func lastDay() -> Int {
        let calendar = defaultCalendar()
        
        // 月末
        let comps = calendar.dateComponents([.year, .month], from: self)
        let add = DateComponents(month: 1, day: -1)
        let lastDate = calendar.date(byAdding: add, to: calendar.date(from: comps)!)
        let day = calendar.component(.day, from: lastDate!)
        return day
    }
    
    func weekDay() -> Int {
        let calendar = defaultCalendar()
        let comps = calendar.dateComponents([.weekday], from: self)
        
        guard let week = comps.weekday else {
            return -1
        }
        
        return week
    }
    
    func weekDayString() -> String {
        // ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
        //Calendar.current.standaloneWeekdaySymbols
        
        // ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        let week = self.weekDay()
        
        if week == -1 {
            return ""
        }
        
        let calendar = defaultCalendar()
        
        return calendar.shortStandaloneWeekdaySymbols[week-1]
        
    }
    
    func isHoliday() -> Bool {
        
        let week = weekDay()
        
        switch(week){
        case 1,7:
            return true
        default:
            return false
        }
    }
}
