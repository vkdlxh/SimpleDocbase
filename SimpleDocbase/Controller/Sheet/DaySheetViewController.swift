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
        
        if let yearmonth = workDate?.yearMonthString() {
            self.title = yearmonth + "_勤務表"
        }
        
        receiveValue()
        if let groupId = getSelectedGoupdId() {
            self.groupId = groupId
        }
    }
    
    // MARK: Action
    @objc func uploadButtonTouched(_ sender: UIBarButtonItem) {
        //入力された勤務表をDocbaseへアップロード
        var uploadAlertVC = UIAlertController()
        if groupId == nil {
            uploadAlertVC = UIAlertController(title: "アップロード失敗", message: "勤怠管理のグループを確認してください。", preferredStyle: .alert)
            uploadAlertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler:nil))
            
        } else {
            uploadAlertVC = UIAlertController(title: "アップロード", message: "勤務表をDocbaseへ登録しますか。", preferredStyle: .alert)
            uploadAlertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) in
                
                // Test
                let testMemo: [String : Any] = [
                    "title": "Test WorkSheet",
                    "body": "Test WorkSheet",
                    "draft": false,
                    "tags": ["Test WorkSheet"],
                    "scope": "group",
                    "groups": [self.groupId],
                    "notice": true
                ]
                
                //TODO: メモ投稿処理
                ACAMemoRequest().writeMemo(domain: self.domain, dict: testMemo, completion: { result in
                    self.checkUploadSuccessAlert(result: result)
                })
                print("post memo!")
            }))
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
    
}


// MARK: Extensions
extension DaySheetViewController : UITableViewDelegate {
    
    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0;
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let editVC = DaySheetEditViewController()
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
