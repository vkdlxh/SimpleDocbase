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
    
    var worksheetDict: [String: Any] = [:]
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
        
        print(worksheetDict)
        
    }
    
    internal func saveLocalWorkSheet(_ filename: String, workSheet: WorkSheet) {
        //TODO: 保存、すでに存在したら上書き
        let workSheetDict = workSheet.convertworkSheetTodictionary()
        
        saveToJsonFile(filename, workSheetDict: workSheetDict)
    }
    
    internal func removeLocalWorkSheet() {
        //TODO: 削除、存在しなければ無視
        let fileManager = FileManager.default
        guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileUrl = documentDirectoryUrl.appendingPathComponent("test.json")
        let fileUrlPath = fileUrl.path
        
        do {
            if(FileManager.default.fileExists(atPath: fileUrlPath)) {
                print("file exists.")
                try fileManager.removeItem(atPath: fileUrlPath)
            } else {
                print("file not exists.")
            }
        } catch {
            print("could not remove file.")
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
    
    private func saveToJsonFile(_ filename: String, workSheetDict: [String: Any]) {
        
        worksheetDict[filename] = workSheetDict
        
        guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        let fileUrl = documentDirectoryUrl.appendingPathComponent("test.json")

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
