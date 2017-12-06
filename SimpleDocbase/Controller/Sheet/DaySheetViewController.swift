//
//  DaySheetViewController.swift
//  SimpleDocbase
//
//  Created by jaeeun on 2017/11/11.
//  Copyright © 2017年 archive-asia. All rights reserved.
//

import UIKit

final class DaySheetViewController : UIViewController {
    
    // MARK: Properties
    var workDate: Date?
    var sheetItems: [WorkSheetItem]?
    var groups: [Group] = []
    var groupId: Int?
    let domain = UserDefaults.standard.object(forKey: "selectedTeam") as! String
    var group = UserDefaults.standard.object(forKey: "selectedGroup") as? String
    
    // Test
    var testArary = [WorkSheet]()
    
    // MARK: IBOutlet
    @IBOutlet var daySheetTableView: UITableView!
    @IBOutlet var daySheetHeaderView: DaySheetHeaderView!
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initControls()
        
        // Test
        loadTestData()
        let workMG = WorkSheetManager.sharedManager
        guard let yearmonth = workDate?.yearMonthString() else {
            return
        }
        if let testWorkSheet = testArary.first {
            workMG.saveLocalWorkSheet(yearmonth, workSheet: testWorkSheet)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let yearmonth = workDate?.yearMonthString() {
            self.title = yearmonth + "_勤務表"
        }
        
        receiveValue()
        if let groupId = getSelectedGoupdId() {
            self.groupId = groupId
        }
    }
    
    // MARK: Action
    
    // Test
    @objc func uploadButtonTouched(_ sender: UIBarButtonItem) {
        
        // Test
//        let worksheetManager = TestWorkSheetManager.sharedManager
//        worksheetManager.loadLocalWorkSheets()
//        let worksheetDict = worksheetManager.worksheetDict
//        guard let yearmonth = workDate?.yearMonthString() else {
//            return
//        }
        
        let worksheetManager = WorkSheetManager.sharedManager
        worksheetManager.loadLocalWorkSheets()
        let worksheetDict = worksheetManager.worksheetDict
        guard let yearmonth = workDate?.yearMonthString() else {
            return
        }
        
        //入力された勤務表をDocbaseへアップロード
        var uploadAlertVC = UIAlertController()
        if groupId == nil {
            uploadAlertVC = UIAlertController(title: "アップロード失敗", message: "勤怠管理のグループを確認してください。", preferredStyle: .alert)
            uploadAlertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler:nil))
            
        } else {
            uploadAlertVC = UIAlertController(title: "アップロード", message: "勤務表をDocbaseへ登録しますか。", preferredStyle: .alert)
            uploadAlertVC.addAction(UIAlertAction(title: "OK", style: .default) { action in
                // Test
                if let groupid = self.groupId {
                    worksheetManager.uploadWorkSheet(domain: self.domain, month: yearmonth, groupId: groupid, dict: worksheetDict) { result in
                        self.checkUploadSuccessAlert(result: result)
                    }
                }
            })
            uploadAlertVC.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler:nil))
        }
        present(uploadAlertVC, animated: true, completion: nil)
    }
    
    func checkUploadSuccessAlert(result: Bool) {
        
        var ac = UIAlertController()
        
        if result == true {
            ac = UIAlertController(title: "Upload成功", message: nil, preferredStyle: .alert)
            let successAction = UIAlertAction(title: "OK", style: .default) { action in
                print("WorkSheet Upload Success.")
            }
            ac.addAction(successAction)
            
        } else {
            ac = UIAlertController(title: "Upload失敗", message: nil, preferredStyle: .alert)
            let failAction: UIAlertAction = UIAlertAction(title: "OK", style: .cancel) {
                (action: UIAlertAction!) -> Void in
                print("WorkSheet Upload Success.")
            }
            ac.addAction(failAction)
        }
        
        DispatchQueue.main.async {
            self.present(ac, animated: true, completion: nil)
        }
        
    }
    
    func getSelectedGoupdId() -> Int? {
        
        let groupId = groups.filter { $0.name == self.group }.first?.id
        
        guard let selectedGroupId = groupId else { return nil }
        
        return selectedGroupId
    }
    
    func receiveValue() {
        group = UserDefaults.standard.object(forKey: "selectedGroup") as? String
        print("receive Group")
    }
    
    // MARK: Private
    private func initControls() {
        
        let uploadBarButton = UIBarButtonItem(barButtonSystemItem: .action,
                                              target: self,
                                              action: #selector(DaySheetViewController.uploadButtonTouched(_ :)))
        
        navigationItem.rightBarButtonItems = [uploadBarButton]
    }
    
    // Test
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
                work_sheet.items.append(work_sheet_item)
            }
            testArary.append(work_sheet)
        }
    }
    
}


// MARK: Extensions
extension DaySheetViewController : UITableViewDelegate {
    
    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0;
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let editVC = DaySheetEditViewController()
        let sheetItem = sheetItems?[indexPath.row]
        
        //MARK: test code.
        //実際のデータを渡すようにしてください。これはテストデータです。
        //editVC.worksheetItem = sheetItem
        var test_item = WorkSheetItem(year: 2017, month: 1, day: 22)
        test_item.workFlag = true
        test_item.beginTime = Date(timeIntervalSinceNow: -1*60*60*9)    //9時間前に。。
        test_item.endTime = Date()
        test_item.remark = "dummy data."
        editVC.worksheetItem = test_item
        ///// test code.
        
        navigationController?.pushViewController(editVC, animated: true)
    }
    
    internal func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return daySheetHeaderView;
    }
}

extension DaySheetViewController : UITableViewDataSource {
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sheetItems?.count ?? 0
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorkSheetItemCell") as! WorkSheetItemCell
        
        let sheetItem = sheetItems?[indexPath.row]
        cell.settingCell(sheetItem!)
        
        return cell
    }
    
}
