//
//  WorkSheetManager.swift
//  SimpleDocbase
//
//  Created by jaeeun on 2017/11/23.
//  Copyright © 2017年 archive-asia. All rights reserved.
//

import UIKit
//        dayLabel.text       = "日"
//        weekLabel.text      = "曜日"
//        workDayLabel.text   = "作業日"
//        beginTimeLabel.text = "開始時間"
//        endTimeLabel.text   = "終了時間"
//        breakTimeLabel.text = "休憩"
//        workTimeLabel.text  = "勤務時間"
//        remarkLabel.text    = "備考"
/*
 
 | 日 | 曜日 | 作業日 | 開始時間| 終了時間 | 休憩 | 勤務時間 | 備考 |
 |:--:|:---:|:-----:|:------:|:------:|:---:|:------:|:----:|
 | row1 | row1 | row1 | row1 | row1 | row1 | row1 | row1 |
 | row2 | row2 | row2 | row2 | row2 | row2 | row2 | row2 |
 ...
 */
 
class WorkSheetManager: NSObject {
    
    private let docSignCreateby = "<!-- generated from SimpleDocbase. -->"
    private let headerColumn = "| 日 | 曜日 | 作業日 | 開始時間| 終了時間 | 休憩 | 勤務時間 | 備考 |"
    private let headerLine = "|:--:|:---:|:-----:|:------:|:------:|:---:|:------:|:----:|"
    
    private let filenamePrifix = "worksheet_"   //例）worksheet_201711 worksheet.json
    
    //singleton
    static let sharedManager = WorkSheetManager()
    override private init() {
        //
    }
    
    //MARK: Internal - File
    internal func createWorkSheet(_ yyyymm :String ) -> WorkSheet? {

        let yearString = yyyymm[..<yyyymm.index(yyyymm.startIndex, offsetBy: 4)]
        let monthString = yyyymm[yyyymm.index(yyyymm.startIndex, offsetBy: 4)...]
        let year = Int(yearString)!
        let month = Int(monthString)!

        let workDate = Date.createDate(year: year, month: month)
        
        guard let work_date = workDate else {
            return nil
        }
        
        var work_sheet = WorkSheet(date:work_date)
        work_sheet.workDaySum = 10 + Int(arc4random()%10)
        work_sheet.workTimeSum = Double(120) + Double(arc4random()%20)
        var items = [WorkSheetItem]()
        for day in 1...work_date.lastDay() {
            var work_sheet_item = WorkSheetItem(year: year, month:month, day:day)
            work_sheet_item.beginTime = nil//Date()
            work_sheet_item.endTime = nil//Date()
            work_sheet_item.breakTime = 1.0
            work_sheet_item.duration = 8.0
            work_sheet_item.remark = ""
            work_sheet_item.week = work_date.weekDay()
            work_sheet_item.workFlag = !work_date.isHoliday()
            items.append(work_sheet_item)
        }
        
        work_sheet.items = items
        
        return work_sheet
    }
    
    internal func loadLocalWorkSheets() -> Array<WorkSheet>? {
        
        //worksheet_から始まるファイル全て取得
        
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        
        var fileNames: [String] {
            do {
                return try FileManager.default.contentsOfDirectory(atPath: documentPath)
            } catch {
                return []
            }
        }
    
        let worksheetNames = fileNames.filter({ (fname: String) -> Bool in
                return fname.hasPrefix(filenamePrifix)
        })
        
        print("worhsheet list:", worksheetNames)
            
            
        //Dictionaryへ変換
        var worksheets = [WorkSheet]()
        guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
    
        for filename in worksheetNames {
            
            let fileUrl = documentDirectoryUrl.appendingPathComponent(filename + ".json")
            guard let jsonData = try? Data(contentsOf: fileUrl) else {
                continue
                
            }
            guard let jsonString = String(data: jsonData, encoding: .utf8) else {
                continue
            }
            
            print("jsonString \(jsonString)") // This prints what looks to be JSON encoded data.
            
            guard let jsonDict = convertToDictionary(jsonString) else {
                continue
            }
            
            print("jsonDict \(jsonDict)")
            let w = WorkSheet(dict: jsonDict)
            
            worksheets.append(w)
        }
        
        return worksheets
        
    }
    
    internal func saveLocalWorkSheet(_ :WorkSheet) {
        //TODO: 保存、すでに存在したら上書き
        
    }
    
    internal func removeLocalWorkSheet(_ :WorkSheet) {
        //TODO: 削除、存在しなければ無視
        
    }
    
    //MARK: Internal - Request
    internal func uploadWorkSheet(_ :WorkSheet) {
        //TODO: Docbaseへアップロード
    }
    
    //MARK: Private
    private func generateWorksheetMarkdown(_ items: Array<WorkSheetItem>) -> String {
        
        var markdownStr = docSignCreateby + "\n" +
                        headerColumn + "\n" +
                        headerLine + "\n"
        
        for item: WorkSheetItem in items {
            markdownStr += "| "
            
            if let workDay = item.workDay {
                markdownStr += String(workDay) + "| "
            }
            
            if let week = item.week {
                markdownStr += Date.weekDayString(week: week)
            }
            markdownStr += "| "
            
            if let workFlag = item.workFlag {
                markdownStr += String(workFlag)
            }
            markdownStr += "| "
            
            if let beginTime = item.beginTime {
                markdownStr += beginTime.hourMinuteString()
            }
            markdownStr += "| "
            
            if let endTime = item.endTime {
                markdownStr += endTime.hourMinuteString()
            }
            markdownStr += "| "
            
            if let breakTime = item.breakTime {
                markdownStr += String(breakTime)
            }
            markdownStr += "| "
            
            if let duration = item.duration {
                markdownStr += String(duration)
            }
            markdownStr += "| "
            
            if let remark = item.remark {
                markdownStr += remark
            }
            markdownStr += "| \n"
        }
        
        return markdownStr
    }
    
    private func saveToJsonFile(_ filename: String, workSheet: WorkSheet) {
        
        guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        let fileUrl = documentDirectoryUrl.appendingPathComponent(filename + ".json")
        
        do {
            let data = try JSONSerialization.data(withJSONObject: workSheet, options: [])
            try data.write(to: fileUrl, options: [])
        } catch {
            print(error)
        }
    }
    
    private func convertToDictionary(_ text: String) -> [String: Any]? {
        
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}
