//
//  WriteMemoViewController.swift
//  SimpleDocbase
//
//  Created by jeonsangjun on 2017/11/02.
//  Copyright © 2017年 archive-asia. All rights reserved.
//

import UIKit

protocol WriteMemoViewControllerDelegate {
    func writeMemoViewSubmit()
}

class WriteMemoViewController: UIViewController {
    
    // MARK: Properties
    var delegate: WriteMemoViewControllerDelegate?
    let domain = UserDefaults.standard.object(forKey: "selectedTeam") as? String
    var group: Group?
    var checkWriteSuccess = false
    let tagValue = "iPhoneから投稿"
    
    // MARK: IBOutlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var tagLabel: UILabel!
    // MARK: IBActions
    @IBAction func submitMemoButton(_ sender: Any) {
        if let textField = titleTextField.text, textField.isEmpty {
            emptyTextValue(errorPlace: "タイトル")
        } else if let textField = bodyTextView.text, textField.isEmpty {
            emptyTextValue(errorPlace: "メモの内容")
        } else {
            let memo: [String : Any] = [
            "title": titleTextField.text ?? "" ,
            "body": bodyTextView.text ?? "" ,
            "draft": false,
            "tags": [tagValue],
            "scope": "group",
            "groups": [group?.id],
            "notice": true
            ]
            
            if let domain = domain {
                DispatchQueue.global().async {
                    ACAMemoRequest().writeMemo(domain: domain, dict: memo) { check in
                        if check == true {
                            self.checkWriteSuccess = true
                        }
                        self.checkWriteSuccessAlert(result: self.checkWriteSuccess)

                    }
                }
            }
        }
    }
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let groupName = group?.name {
            navigationItem.title = groupName
        }
        tagLabel.text = "タグ：" + tagValue
    
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.view.endEditing(true)
    }
    
    
    // MARK: Internal Methods
    @objc func keyboardWillShow(_ notification: Notification) {
        let userInfo = (notification as NSNotification).userInfo!
        let keyboardHeight =  (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        bottomConstraint.constant = keyboardHeight.height
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        bottomConstraint.constant = 0
    }
    
    private func checkWriteSuccessAlert(result: Bool) {
        
        var ac = UIAlertController()
        
        if result == true {
            ac = UIAlertController(title: "メモ登録成功", message: nil, preferredStyle: .alert)
            let successAction = UIAlertAction(title: "確認", style: .default) { action in
                print("Write Memo Success")
                self.view.endEditing(true)
                DispatchQueue.main.async {
                    self.delegate?.writeMemoViewSubmit()
                }
            }
            ac.addAction(successAction)
            
        } else {
            ac = UIAlertController(title: "メモ登録失敗", message: nil, preferredStyle: .alert)
            let failAction: UIAlertAction = UIAlertAction(title: "確認", style: .cancel) {
                (action: UIAlertAction!) -> Void in
                print("Write Memo Faill")
            }
            ac.addAction(failAction)
        }
        
        DispatchQueue.main.async {
            self.present(ac, animated: true, completion: nil)
        }
    }
    
    private func emptyTextValue(errorPlace: String) {
        let ac = UIAlertController(title: errorPlace + "を確認してください。", message: nil, preferredStyle: .alert)
        let okAction: UIAlertAction = UIAlertAction(title: "確認", style: .cancel) {
            (action: UIAlertAction!) -> Void in
            print(errorPlace + " is Empty.")
        }
        ac.addAction(okAction)
        self.present(ac, animated: true, completion: nil)
    }
}
