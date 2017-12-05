//
//  TesterWorkSheetViewController.swift
//  SimpleDocbase
//
//  Created by jeonsangjun on 2017/12/05.
//  Copyright © 2017年 archive-asia. All rights reserved.
//

import UIKit

class TesterWorkSheetViewController: UIViewController {

    let worksheetManager = TestWorkSheetManager.sharedManager
    
    var testArary = [WorkSheet]()
    
//    let testDict = ["Key1" : "value1",
//                    "Key2" : "value2",
//                    "Key3" : "value3",
//                    "Key4" : "value4",]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadTestData()
        
//        let workSheetDict = testArary.first?.convertworkSheetTodictionary()
//        print(workSheetDict)
        
        
        
        
        let testFileName = "201712"
        guard let testWorkSheet = testArary.first else { return }

        testSaveToJsonFile(testFileName, workSheet: testWorkSheet)
//
//        if let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
//            let fileUrl = documentDirectoryUrl.appendingPathComponent("test.json")
//            let fileUrlPath = fileUrl.path
//            if(FileManager.default.fileExists(atPath: fileUrlPath)) {
//                print("file exists")
//                worksheetManager.loadLocalWorkSheets()
//            }
//        }
//
//        worksheetManager.saveLocalWorkSheet(testFileName, workSheet: testWorkSheet)
        
    }

//    func testSaveWorkSheet() {
//        let fileName = "201712"
//        let workSheet = WorkSheet
//        worksheetManager.saveLocalWorkSheet(<#T##filename: String##String#>, workSheet: <#T##WorkSheet#>)
//    }
    
    
    func testSaveToJsonFile(_ filename: String, workSheet: WorkSheet) {

        guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }

        let fileUrl = documentDirectoryUrl.appendingPathComponent(filename + ".json")
        let workSheetDict = workSheet.convertworkSheetTodictionary()
        
        do {
            let data = try JSONSerialization.data(withJSONObject: workSheetDict, options: [])
            try data.write(to: fileUrl, options: [])
        } catch {
            print(error)
        }
    }
    
    
    // MARK: Private Methods
    private func loadTestData() {
        for i in 0..<10 {
            guard let year_month = Date.createDate(year: 2017, month: i+1) else {
                continue
            }
            var work_sheet = WorkSheet(date:year_month)
            work_sheet.workDaySum = 10 + Int(arc4random()%10)
            work_sheet.workTimeSum = Double(120) + Double(arc4random()%20)
            for j in 0..<31 {
                let work_sheet_item = WorkSheetItem(year: 2017, month:i, day:j)
                work_sheet.items.append(work_sheet_item)
            }
            testArary.append(work_sheet)
        }
    }

}
