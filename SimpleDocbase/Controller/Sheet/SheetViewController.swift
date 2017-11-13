//
//  SheetViewController.swift
//  SimpleDocbase
//
//  Created by jeonsangjun on 2017/11/07.
//  Copyright © 2017年 archive-asia. All rights reserved.
//

import UIKit

final class SheetViewController : UIViewController {

    // MARK: Properties
    var workSheets = [WorkSheet]()
    var selectedSheetItem : WorkSheetItem?
    
    // MARK: IBOutlets
    @IBOutlet weak var sheetTableView: UITableView?
    
    // MARK: IBActions
    
    // MARK: Initializer
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "勤怠管理"
        
        // Do any additional setup after loading the view.
        //REMARK: テストデータ
        loadTestData()
        
     }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "GoDetailWorkSheetSegue" {
            if let destination = segue.destination as? DaySheetViewController {
                if let selectedSheetItem = selectedSheetItem {
                    destination.sheetItem = selectedSheetItem
                }
            }
        }
        
    }
 

    // MARK: Internal Methods
    
    
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
                let work_sheet_item = WorkSheetItem(year: "2017", month: "\(i)", day: "\(j)")
                work_sheet.items.append(work_sheet_item)
            }
            workSheets.append(work_sheet)
        }
    }
}


// MARK: Extensions
extension SheetViewController : UITableViewDelegate {
    
    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0;
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.performSegue(withIdentifier: "GoDetailWorkSheetSegue", sender: self)
    }
}

extension SheetViewController : UITableViewDataSource {
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workSheets.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorkSheetCell") as! WorkSheetCell
        
        let workSheet = workSheets[indexPath.row]
        cell.settingCell(workSheet)
        
        return cell
    }

}




