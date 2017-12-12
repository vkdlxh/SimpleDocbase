//
//  String+WorkSheet.swift
//  SimpleDocbase
//
//  Created by jeonsangjun on 2017/12/08.
//  Copyright © 2017年 archive-asia. All rights reserved.
//

import Foundation

extension String {
    func stringDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
        let date = dateFormatter.date(from:self)!
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour], from: date)
        let finalDate = calendar.date(from:components)
        return finalDate
    }
}
