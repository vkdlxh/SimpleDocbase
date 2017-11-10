//
//  SheetViewController.swift
//  SimpleDocbase
//
//  Created by jeonsangjun on 2017/11/07.
//  Copyright © 2017年 archive-asia. All rights reserved.
//

import UIKit

class SheetViewController: UIViewController {

    // MARK: Properties
    var workSheets = [WorkSheet]()
    
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: Internal Methods
    
    
    // MARK: Private Methods
    private func loadTestData() {
        for i in 0..<10 {
            var work_sheet = WorkSheet(title: "タイトル_\(i)")
            
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
        return 44.0;
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //TODO:　詳細へ遷移
    }
}

extension SheetViewController : UITableViewDataSource {
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workSheets.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: .default, reuseIdentifier: "WorkSheetCell")
        
        let workSheet = workSheets[indexPath.row]
        cell.textLabel?.text = workSheet.title
        return cell
    }

}




