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
    var selectedWorkSheet : WorkSheet?
    let worksheetManager = WorkSheetManager.sharedManager
    let limitLength = 6
    
    // MARK: IBOutlets
    @IBOutlet weak var sheetTableView: UITableView?
    @IBOutlet weak var messageLabel: UILabel?
    
    // MARK: IBActions
    
    // MARK: Initializer
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "勤怠管理"
        
        initControls()
        
        // Do any additional setup after loading the view.
     }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        insertWorkSheetAferloadLoaclWorkSheet()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Actinos
    @objc func addSheetButtonTouched(_ sender: UIBarButtonItem) {
        
        print("addSheetButtonTouched!!")
        
        let alert = UIAlertController(title:"勤務表追加",
                                      message: "作成する年月を入力してください。",
                                      preferredStyle: .alert)
        
        alert.addTextField { (textfield : UITextField) in
            textfield.placeholder = "YYYYMM"
            textfield.delegate = self
        }

        alert.addAction(UIAlertAction(title: "キャンセル",
                                      style: .cancel,
                                      handler:nil))
        
        alert.addAction(UIAlertAction(title: "確認", style: .default) { action in
            print("OK")

            let textFields:Array<UITextField>? =  alert.textFields as Array<UITextField>?
            if textFields != nil {
                for textField:UITextField in textFields! {
                    //TODO: 6桁数字なのかをチェック
                    if textField.text?.count != 6 || (textField.text?.isInt) == false {
                        let alert = UIAlertController(title:"勤務表追加失敗",
                                                      message: "YYYYMMの形式で入力してください。",
                                                      preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "確認",
                                                      style: .cancel) { action in
                            })
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        guard let yyyymm = textField.text else {
                            return
                        }
                        
                        let test_worksheet = self.worksheetManager.createWorkSheet(yyyymm)
                        
                        //TODO: 生成されたmodelをjson形式で保存
                        if let testWorkSheet = test_worksheet {
                            self.worksheetManager.checkKeyHadValue(yyyymm) { check in
                                if check == true {
                                    self.alreadyWorkSheetHadValueAlert(yyyymm, workSheet: testWorkSheet)
                                } else {
                                    self.worksheetManager.saveLocalWorkSheet(yyyymm, workSheet: testWorkSheet)
                                }
                            }
                            
                        }
                        self.insertWorkSheetAferloadLoaclWorkSheet()
                    }
                }
            }
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "GoDetailWorkSheetSegue" {
            if let destination = segue.destination as? DaySheetViewController {
                if let selectedWorkSheet = selectedWorkSheet {
                    if let yearMonth = selectedWorkSheet.workdate?.yearMonthKey() {
                        destination.yearMonth = yearMonth
                    }
//                    destination.groups = groups
                }
            }
        }
    }
 
    // MARK: Internal Methods
    
    // MARK: Private Methods
    private func initControls() {
        sheetTableView?.backgroundView = messageLabel;
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(SheetViewController.addSheetButtonTouched(_ :)))
        self.navigationItem.rightBarButtonItems = [addButton]
    }
    
    private func emptyMessage(_ on: Bool) {
        messageLabel?.isHidden = !on
    }
    
    private func insertWorkSheetAferloadLoaclWorkSheet() {
        workSheets.removeAll()
        worksheetManager.loadLocalWorkSheets()
        let workSheetDict = worksheetManager.worksheetDict
        for dictValue in workSheetDict.values {
            if let dictValue = dictValue as? [String: Any] {
                let workSheet = WorkSheet(dict: dictValue)
                workSheets.append(workSheet)
            }
        }
        workSheets.sort { firstWorkSheet, secondWorkSheet -> Bool in
            guard let firstWorkSheet = firstWorkSheet.workdate?.MonthInt() else {
                return false
            }
            guard let secondWorkSheet = secondWorkSheet.workdate?.MonthInt() else {
                return false
            }
            return firstWorkSheet < secondWorkSheet
        }
        sheetTableView?.reloadData()
    }
    
    private func alreadyWorkSheetHadValueAlert(_ jsonKeyMonth: String, workSheet: WorkSheet) {
        let addWorkSheetAC = UIAlertController(title: "すでにある勤務表です。", message: "本当に上書きしますか。", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "登録", style: .default) { action in
            self.worksheetManager.saveLocalWorkSheet(jsonKeyMonth, workSheet: workSheet)
            self.insertWorkSheetAferloadLoaclWorkSheet()
        }
        let cancelButton = UIAlertAction(title: "キャンセル", style: .cancel) { action in
        }
        
        addWorkSheetAC.addAction(okButton)
        addWorkSheetAC.addAction(cancelButton)
        present(addWorkSheetAC, animated: true, completion: nil)
    }
    
    private func deleteWorkSheetAlert(completion: @escaping (Bool) -> ()) {
        let deleteWorkSheetAC = UIAlertController(title: "勤務表削除", message: "本当に勤務表を削除しますか？", preferredStyle: .alert)
        let deleteButton = UIAlertAction(title: "削除", style: .default) { action in
            completion(true)
            print("tapped WorkSheet delete Button")
        }
        let cancelButton = UIAlertAction(title: "キャンセル", style: .cancel) { action in
            completion(false)
            print("tapped WorkSheet cancel Button")
        }
        
        deleteWorkSheetAC.addAction(deleteButton)
        deleteWorkSheetAC.addAction(cancelButton)
        present(deleteWorkSheetAC, animated: true, completion: nil)
    }
    
}

// MARK: Extensions
extension SheetViewController : UITableViewDelegate {
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        selectedWorkSheet = workSheets[indexPath.row]
        self.performSegue(withIdentifier: "GoDetailWorkSheetSegue", sender: self)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteButton: UITableViewRowAction = UITableViewRowAction(style: .normal, title: "削除") { (action, index) -> Void in
            
            //TODO: 勤務表削除アラート
            self.deleteWorkSheetAlert { check in
                if check == true {
                    
                    //TODO: delete worksheet in jsonfile
                    let selectedWorkSheet = self.workSheets[indexPath.row]
                    
                    if let key = selectedWorkSheet.workdate?.yearMonthKey() {
                        self.worksheetManager.removeLocalWorkSheet(yearMonth: key)
                        self.workSheets.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .fade)
                        self.insertWorkSheetAferloadLoaclWorkSheet()
                    }
                } else {
                    tableView.setEditing(false, animated: true)
                }
            }
        }
        
        deleteButton.backgroundColor = UIColor.red
        
        return [deleteButton]
    }
}

extension SheetViewController : UITableViewDataSource {
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        emptyMessage(workSheets.count == 0)
        
        return workSheets.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorkSheetCell") as! WorkSheetCell
        
        let workSheet = workSheets[indexPath.row]
        cell.settingCell(workSheet)
        
        return cell
    }

}

extension SheetViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= limitLength
    }
}
