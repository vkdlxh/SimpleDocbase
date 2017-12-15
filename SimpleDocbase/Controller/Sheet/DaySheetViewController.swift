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
            uploadAlertVC.addAction(UIAlertAction(title: "確認", style: .cancel, handler:nil))
            
        } else {
            uploadAlertVC = UIAlertController(title: group!, message: "勤務表を上記のグループへ登録しますか。", preferredStyle: .alert)
            uploadAlertVC.addAction(UIAlertAction(title: "確認", style: .default) { action in
                // Test
                SVProgressHUD.show(withStatus: "アップロード中")
                if let groupid = self.groupId {
                    if let domain = self.domain {
                        self.workSheetManager.uploadWorkSheet(domain: domain, month: self.yearMonth, groupId: groupid, dict: worksheetDict) { result in
                            self.checkUploadSuccessAlert(result: result)
                            DispatchQueue.main.async {
                                SVProgressHUD.dismiss()
                            }
                        }
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
            ac = UIAlertController(title: "アップロード成功", message: "勤務表をアップロードしました。\nDocBaseからご確認ください。", preferredStyle: .alert)
            let successAction = UIAlertAction(title: "確認", style: .default) { action in
                print("WorkSheet Upload Success.")
            }
            ac.addAction(successAction)
            
        } else {
            ac = UIAlertController(title: "アップロード失敗", message: nil, preferredStyle: .alert)
            let failAction: UIAlertAction = UIAlertAction(title: "確認", style: .cancel) {
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

