//
//  DaySheetViewController.swift
//  SimpleDocbase
//
//  Created by jaeeun on 2017/11/11.
//  Copyright © 2017年 archive-asia. All rights reserved.
//

import UIKit

final class DaySheetViewController : UIViewController {
    
    var groups: [Group] = []
    var groupId: Int?
    let domain = UserDefaults.standard.object(forKey: "selectedTeam") as! String
    var group = UserDefaults.standard.object(forKey: "selectedGroup") as? String

    //TODO: WorkSheetDictのKey(yearMonth)を使ってWorkSheetを呼び出す
    let workSheetManager = WorkSheetManager.sharedManager
    var workSheet: WorkSheet?
    var yearMonth: String = ""
    var sheetItems: [WorkSheetItem]?
    
    // MARK: IBOutlet
    @IBOutlet var daySheetTableView: UITableView!
    @IBOutlet var daySheetHeaderView: DaySheetHeaderView!
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initControls()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = yearMonth + "_勤務表"
        
        receiveValue()
    }
    
    // MARK: Action
    
    @objc func uploadButtonTouched(_ sender: UIBarButtonItem) {
        
        let worksheetDict = workSheetManager.worksheetDict
        
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
                    self.workSheetManager.uploadWorkSheet(domain: self.domain, month: self.yearMonth, groupId: groupid, dict: worksheetDict) { result in
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
    
    // MARK: Private
    private func getSelectedGoupdId() -> Int? {
        
        let groupId = groups.filter { $0.name == self.group }.first?.id
        
        guard let selectedGroupId = groupId else { return nil }
        
        return selectedGroupId
    }
    
    private func receiveValue() {
        if let groupId = getSelectedGoupdId() {
            self.groupId = groupId
        }
        group = UserDefaults.standard.object(forKey: "selectedGroup") as? String
        print("receive Group")
        workSheet = workSheetManager.findWorkSheetFromWorkSheetDict(yearMonth: yearMonth)
        sheetItems = workSheet?.items
        
        daySheetTableView.reloadData()
    }
    
    private func initControls() {
        
        let uploadBarButton = UIBarButtonItem(barButtonSystemItem: .action,
                                              target: self,
                                              action: #selector(DaySheetViewController.uploadButtonTouched(_ :)))
        
        navigationItem.rightBarButtonItems = [uploadBarButton]
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
        editVC.worksheetItem = sheetItem
        
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

