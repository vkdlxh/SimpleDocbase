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
    
    var worksheetDict: [String: Any] = [:]
    private let docSignCreateby = "<!-- generated from SimpleDocbase. -->"
    private let headerColumn = "| 日 | 曜日 | 作業日 | 開始時間| 終了時間 | 休憩 | 勤務時間 | 備考 |"
    private let headerLine = "|:--:|:---:|:-----:|:------:|:------:|:---:|:------:|:----:|"
    private let fileName = "worksheet"   //例）worksheet.json
    
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

//        let workDate = Date.createDate(year: year, month: month)
        
        let workDate = Date.createDate(yyyymm: yyyymm)
        
        guard let work_date = workDate else {
            return nil
        }
        
        var work_sheet = WorkSheet(date:work_date)
        var items: [WorkSheetItem] = []
        for day in 1...work_date.lastDay() {
            var work_sheet_item = WorkSheetItem(year: year, month:month, day:day)
            work_sheet_item.beginTime = nil//Date()
            work_sheet_item.endTime = nil//Date()
            work_sheet_item.breakTime = 1.0
//            work_sheet_item.duration = 8.0
            work_sheet_item.remark = ""
            items.append(work_sheet_item)
        }
        work_sheet.items = items
        
        return work_sheet
    }
    
    internal func loadLocalWorkSheets() {
        //worksheet_から始まるファイル全て取得
        
        //Dictionaryへ変換
        guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileUrl = documentDirectoryUrl.appendingPathComponent(fileName + ".json")
        
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
        
//        print(worksheetDict)
    }
    
    internal func saveLocalWorkSheet(_ jsonKeyMonth: String, workSheet: WorkSheet) {
        //TODO: 保存、すでに存在したら上書き
        let workSheetDict = workSheet.convertworkSheetTodictionary()
        
        saveToJsonFile(jsonKeyMonth, workSheetDict: workSheetDict)
    }
    
    internal func removeLocalWorkSheet(yearMonth: String) {
        //TODO: 削除、存在しなければ無視
        worksheetDict.removeValue(forKey: yearMonth)
        
        guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        let fileUrl = documentDirectoryUrl.appendingPathComponent(fileName + ".json")
        
        do {
            let data = try JSONSerialization.data(withJSONObject: worksheetDict, options: [])
            try data.write(to: fileUrl, options: [])
        } catch {
            print(error)
        }
        
        print("Delete WorkSheet \(yearMonth)")
        
    }
    
    func findWorkSheetFromWorkSheetDict(yearMonth: String) -> WorkSheet? {
        guard let workSheetValue = worksheetDict[yearMonth] as? [String: Any] else {
            return nil
        }
        let workSheet = WorkSheet(dict: workSheetValue)
        return workSheet
    }
    
    func saveSheetItem(yearMonth: String, sheetItems: [WorkSheetItem]) {   
        if var workSheet = findWorkSheetFromWorkSheetDict(yearMonth: yearMonth) {
            var workSheetItems = workSheet.items
            workSheetItems?.removeAll()
            workSheetItems = sheetItems
            
            workSheetItems?.sort(by: { firstItem, secondItem -> Bool in
                guard let firstItemDay = firstItem.workDay else {
                    return false
                }
                guard let secondItemDay = secondItem.workDay else {
                    return false
                }
               return firstItemDay  < secondItemDay
            })
            workSheet.items = workSheetItems
            
            let workTimeSum = workSheetItems?.filter { $0.workFlag == true }.reduce(0) { (sum: Double , item) in
                guard let duration = item.duration else {
                    return sum
                }
                return sum + duration
            }
            workSheet.workTimeSum = workTimeSum
            let workDaySum = workSheetItems?.filter { $0.workFlag == true }.count
            workSheet.workDaySum = workDaySum
            
            saveLocalWorkSheet(yearMonth, workSheet: workSheet)
        }
    }
    
    //MARK: Internal - Request
    internal func uploadWorkSheet(domain: String, month: String, groupId: Int, dict: Dictionary<String, Any>, completion: @escaping (Bool) -> ()) {
        //TODO: Docbaseへアップロード
        let titlePrifix = "SimpleDocbase_"
        guard let selectedMonth = dict[month] as? [String: Any] else {
            return
        }
        let convertWorkSheet = WorkSheet(dict: selectedMonth)
        guard let items = convertWorkSheet.items else {
            return
        }
        let generatedMakedownBody = generateWorksheetMarkdown(items)
        
        // Test
        let worksheetData: [String : Any] = [
            "title": titlePrifix + month,
            "body": generatedMakedownBody,
            "draft": false,
            "tags": ["SimpleDocbase"],
            "scope": "group",
            "groups": [groupId],
            "notice": true
        ]
        
        let acaRequest = ACARequest()
        let session = acaRequest.session
        guard let url = URL(string: "https://api.docbase.io/teams/\(domain)/posts") else { return }
        var request = acaRequest.settingRequest(url: url, httpMethod: .post)
        guard let httpBody = try? JSONSerialization.data(withJSONObject: worksheetData, options: []) else {
            return
        }
        request.httpBody = httpBody
        
        session.dataTask(with: request) { (data, response, error) in
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 201 {
                print("statusCode should be 201, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                completion(false)
            } else {
                completion(true)
            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                }catch {
                    print(error)
                }
            } else {
                completion(false)
                print("FileUpload Fail")
            }
            }.resume()
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
    
    private func saveToJsonFile(_ jsonKeyMonth: String, workSheetDict: [String: Any]) {
        
        worksheetDict[jsonKeyMonth] = workSheetDict
        
        guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        let fileUrl = documentDirectoryUrl.appendingPathComponent(fileName + ".json")
        
        do {
            let data = try JSONSerialization.data(withJSONObject: worksheetDict, options: [])
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
