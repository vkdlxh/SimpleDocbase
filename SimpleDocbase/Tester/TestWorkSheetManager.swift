//
//  TestWorkSheetManager.swift
//  SimpleDocbase
//
//  Created by jeonsangjun on 2017/12/05.
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

class TestWorkSheetManager: NSObject {
    
    internal var worksheetDict: [String: WorkSheet]?
    private let docSignCreateby = "<!-- generated from SimpleDocbase. -->"
    private let headerColumn = "| 日 | 曜日 | 作業日 | 開始時間| 終了時間 | 休憩 | 勤務時間 | 備考 |"
    private let headerLine = "|:--:|:---:|:-----:|:------:|:------:|:---:|:------:|:----:|"
    
    private let filenamePrifix = "worksheet_"   //例）worksheet_201711 worksheet.json
    
    //singleton
    static let sharedManager = TestWorkSheetManager()
    override private init() {
        //
    }
    
    //MARK: Internal - File
    internal func loadLocalWorkSheets() {
        
        //worksheet_から始まるファイル全て取得
        
        //Dictionaryへ変換
        guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileUrl = documentDirectoryUrl.appendingPathComponent("test.json")
        
        guard let jsonData = try? Data(contentsOf: fileUrl) else {
            return
        }
        
        guard let jsonString = String(data: jsonData, encoding: .utf8) else {
            return
        }
        
        guard let jsonDict = convertToDictionary(jsonString) else {
            return
        }
        
        worksheetDict = jsonDict
        
    }
    
    internal func saveLocalWorkSheet(_ filename: String, workSheet: WorkSheet) {
        //TODO: 保存、すでに存在したら上書き
        guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        let fileUrl = documentDirectoryUrl.appendingPathComponent("test.json")
        
        guard let jsonData = try? Data(contentsOf: fileUrl) else {
            return
        }
        
        guard let jsonString = String(data: jsonData, encoding: .utf8) else {
            return
        }
        
        guard var jsonDict = convertToDictionary(jsonString) else {
            return
        }
        
        if let fileName = jsonDict[filename] {
            jsonDict[filename] = workSheet
        } else {
            saveToJsonFile(filename, workSheet: workSheet)
        }

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
        
        let fileUrl = documentDirectoryUrl.appendingPathComponent("test.json")

        do {
            let data = try JSONSerialization.data(withJSONObject: workSheet, options: [])
            try data.write(to: fileUrl, options: [])
        } catch {
            print(error)
        }
        
    }
    
    private func convertToDictionary(_ text: String) -> [String: WorkSheet]? {
        
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: WorkSheet]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}
