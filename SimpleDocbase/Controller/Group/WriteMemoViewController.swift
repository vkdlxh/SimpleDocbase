//
//  WriteMemoViewController.swift
//  SimpleDocbase
//
//  Created by jeonsangjun on 2017/11/02.
//  Copyright © 2017年 jeon sangjun. All rights reserved.
//

import UIKit

protocol WriteMemoViewControllerDelegate {
    func writeMemoViewSubmit()
}

class WriteMemoViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    // MARK: Properties
    var delegate: WriteMemoViewControllerDelegate?
    let groupRequest: GroupRequest = GroupRequest()
    let memoRequest: MemoRequest = MemoRequest()
    let domain = UserDefaults.standard.object(forKey: "selectedDomain") as? String
    var groups = [Group]()
    var groupId: Int = 0
    
    
    // MARK: IBOutlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var tagsTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var groupPickerView: UIPickerView!
    
    // MARK: IBActions
    @IBAction func submitMemoButton(_ sender: Any) {
        
        var tags = [String]()
        guard let tagsText:String = tagsTextField.text else { return }
        let tagArr = tagsText.components(separatedBy: ",")
        
        for tag in tagArr{
            let trimTag = tag.trimmingCharacters(in: .whitespacesAndNewlines)
            tags.append(trimTag)
        }
        
        let memo: [String : Any] = [
            "title": titleTextField.text ?? "" ,
            "body": bodyTextView.text ?? "" ,
            "draft": false,
            "tags": tags,
            "scope": "group",
            "groups": [groupId],
            "notice": true
        ]

        if let domain = domain {
            memoRequest.writeMemo(domain: domain, dict: memo)
        }
        self.delegate?.writeMemoViewSubmit()
        
    }
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        groupPickerView.dataSource = self
        groupPickerView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        groupRequest.delegate = self
        if let domain = domain {
            groupRequest.getGroupList(domain: domain)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return groups.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return groups[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        groupId = groups[row].id
    }
}

extension WriteMemoViewController : RequestDelegate {
    
    func getGroupName(groups: Array<Any>) {
        if let paramGroup = groups as? [Group] {
            self.groups = paramGroup
        }
        DispatchQueue.main.async {
            self.groupPickerView.reloadAllComponents()
        }
    }
}
