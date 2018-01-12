//
//  WriteMemoViewController.swift
//  SimpleDocbase
//
//  Created by jeonsangjun on 2017/11/02.
//  Copyright © 2017年 archive-asia. All rights reserved.
//

import UIKit
import Firebase

protocol WriteMemoViewControllerDelegate {
    func writeMemoViewSubmit()
}

class WriteMemoViewController: UIViewController {
    
    // MARK: Properties
    var delegate: WriteMemoViewControllerDelegate?
    let domain = UserDefaults.standard.object(forKey: "selectedTeam") as? String
    let presentToken = UserDefaults.standard.object(forKey: "tokenKey") as? String
    var group: Group?
    var checkWriteSuccess = false
    let tagValue = "iPhoneから投稿"
    var placeholderLabel : UILabel!
    
    // MARK: IBOutlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var tagImageView: UIImageView!
    @IBOutlet weak var tagView: UIView!
    @IBOutlet weak var separatorLineView1: UIView!
    @IBOutlet weak var separatorLineView2: UIView!
    
    // MARK: IBActions
    @IBAction func submitMemoButton(_ sender: Any) {
        if let textField = titleTextField.text, textField.isEmpty {
            emptyTextValue(errorPlace: "タイトル")
        } else if let textField = bodyTextView.text, textField.isEmpty {
            emptyTextValue(errorPlace: "メモの内容")
        } else {
            self.view.endEditing(true)
            
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
                ACAMemoRequest().writeMemo(domain: domain, dict: memo) { check in
                    if check == true {
                        self.checkWriteSuccess = true
                    }
                    self.checkWriteSuccessAlert(result: self.checkWriteSuccess)

                }
            }
        }
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bodyTextView.delegate = self
        initTextViewPlaceHolder()
        initOutletsSetting()
        
        if let groupName = group?.name {
            navigationItem.title = groupName
        }
    
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkAccount()
    }
    
    // MARK: Internal Methods
    
    // MARK: Private Methods
    @objc private func keyboardWillShow(_ notification: Notification) {
        let userInfo = (notification as NSNotification).userInfo!
        let keyboardHeight =  (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        bottomConstraint.constant = keyboardHeight.height
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        bottomConstraint.constant = 0
    }
    
    private func checkWriteSuccessAlert(result: Bool) {
        
        var ac = UIAlertController()
        
        if result == true {
            ac = UIAlertController(title: "メモを登録しました。", message: nil, preferredStyle: .alert)
            let successAction = UIAlertAction(title: "確認", style: .default) { action in
                print("Write Memo Success")
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
    
    private func initTextViewPlaceHolder() {
        placeholderLabel = UILabel()
        placeholderLabel.text = "メモ"
        placeholderLabel.font = UIFont.italicSystemFont(ofSize: (bodyTextView.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        bodyTextView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (bodyTextView.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !bodyTextView.text.isEmpty
    }
    
    private func checkAccount() {
        if Auth.auth().currentUser == nil {
            let changedAccountAC = UIAlertController(title: "サインアウト", message: "サインアウトされました。", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "確認", style: .default) { action in
                self.navigationController!.popToRootViewController(animated: true)
            }
            changedAccountAC.addAction(okButton)
            present(changedAccountAC, animated: true, completion: nil)
        }
    }
    
    private func initOutletsSetting() {
        separatorLineView1.backgroundColor = ACAColor().ACALightGrayColor
        separatorLineView2.backgroundColor = ACAColor().ACALightGrayColor
        tagLabel.text = tagValue
        if let tagImage = UIImage(named: "Tag") {
            let tintableImage = tagImage.withRenderingMode(.alwaysTemplate)
            tagImageView.image = tintableImage
            tagImageView.tintColor = ACAColor().ACAOrange
        }
    }
}

// MARK: Extensions
extension WriteMemoViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
}
