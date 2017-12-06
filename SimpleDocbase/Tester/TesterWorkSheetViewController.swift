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
    let domain = UserDefaults.standard.object(forKey: "selectedTeam") as! String
    
    var testArary = [WorkSheet]()
    
    @IBAction func testUploadBtn(_ sender: Any) {
//        let worksheetDict = worksheetManager.worksheetDict
//        worksheetManager.uploadWorkSheet(domain: domain, month: "201712", groupId: 3, dict: worksheetDict) { check in
        
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadTestData()

        let testFileName = "201712"
        guard let testWorkSheet = testArary.first else { return }

        worksheetManager.saveLocalWorkSheet(testFileName, workSheet: testWorkSheet)

        if let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileUrl = documentDirectoryUrl.appendingPathComponent("test.json")
            let fileUrlPath = fileUrl.path
            if(FileManager.default.fileExists(atPath: fileUrlPath)) {
                print("file exists")
                worksheetManager.loadLocalWorkSheets()
            }
        }
//        worksheetManager.removeLocalWorkSheet()
        
    }
    
    // MARK: Private Methods
    private func loadTestData() {
        for i in 1..<10 {
            guard let year_month = Date.createDate(year: 2017, month: i+1) else {
                continue
            }
            var work_sheet = WorkSheet(date:year_month)
            work_sheet.workDaySum = 10 + Int(arc4random()%10)
            work_sheet.workTimeSum = Double(120) + Double(arc4random()%20)
            for j in 1..<31 {
                var work_sheet_item = WorkSheetItem(year: 2017, month:i, day:j)
                work_sheet_item.beginTime = Date()
                work_sheet_item.endTime = Date()
                work_sheet_item.breakTime = 1.0
                work_sheet_item.duration = 8.0
                work_sheet_item.remark = "備考"
                work_sheet_item.week = 1
                work_sheet_item.workFlag = false
//                work_sheet.items.append(work_sheet_item)
            }
            testArary.append(work_sheet)
        }
    }

}
