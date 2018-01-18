//
//  DaySheetViewController.swift
//  SimpleDocbase
//
//  Created by jaeeun on 2017/11/11.
//  Copyright © 2017年 archive-asia. All rights reserved.
//

import UIKit
import SVProgressHUD

final class DaySheetViewController : UIViewController {
    
    var groupId: Int?
    var domain = UserDefaults.standard.object(forKey: "selectedTeam") as? String
    var group = UserDefaults.standard.object(forKey: "selectedGroup") as? String

    //TODO: WorkSheetDictのKey(yearMonth)を使ってWorkSheetを呼び出す
    let workSheetManager = WorkSheetManager.sharedManager
    let alertManager = AlertManager()
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
        if groupId == nil || group == nil {
            alertManager.confirmAlert(self, title: "アップロード失敗", message: "勤怠管理のグループを確認してください。") {
            }
        } else {
            alertManager.defaultAlert(self, title: group!, message: "勤務表を上記のグループへ登録しますか。", btnName: "確認") {
                SVProgressHUD.show(withStatus: "アップロード中")
                if let groupid = self.groupId {
                    if let domain = self.domain {
                        self.workSheetManager.uploadWorkSheet(domain: domain, month: self.yearMonth, groupId: groupid, dict: worksheetDict) { result in
                            if result == true {
                                self.alertManager.confirmAlert(self, title: "アップロード成功", message: "勤務表をアップロードしました。\nDocBaseからご確認ください。") {
                                }
                            } else {
                                self.alertManager.confirmAlert(self, title: "アップロード失敗", message: nil) {
                                }
                            }
                            DispatchQueue.main.async {
                                SVProgressHUD.dismiss()
                            }
                        }
                    }
                }
            }
        }
    }
    
    // MARK: Private
    private func receiveValue(){
        group = UserDefaults.standard.object(forKey: "selectedGroup") as? String
        domain = UserDefaults.standard.object(forKey: "selectedTeam") as? String
        
        DispatchQueue.global().async {
            ACAGroupRequest.init().getGroupList { groups in
                if let groups = groups {
                    let selectedGroupId = groups.filter { $0.name == self.group }.first?.id
                    
                    if let selectedGroupId = selectedGroupId {
                        self.groupId = selectedGroupId
                    } else {
                        self.groupId = nil
                    }
                    
                }
            }
            
            DispatchQueue.main.async {
                self.workSheet = self.workSheetManager.findWorkSheetFromWorkSheetDict(yearMonth: self.yearMonth)
                self.sheetItems = self.workSheet?.items
                self.daySheetTableView.reloadData()
            }
        }
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
        // TEST
        sheetItems?.remove(at: indexPath.row)
        editVC.sheetItems = sheetItems
        editVC.yearMonth = self.yearMonth
        
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

