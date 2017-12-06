//
//  DaySheetEditViewController.swift
//  SimpleDocbase
//
//  Created by jaeeun on 2017/11/25.
//  Copyright © 2017年 archive-asia. All rights reserved.
//

import UIKit
import SwiftyFORM

class DaySheetEditViewController: FormViewController {

    var editDate = Date()
    
    override func populate(_ builder: FormBuilder) {
        builder.navigationTitle = editDate.yearMonthDayString()
        
        builder += SectionHeaderTitleFormItem().title("勤務設定")
        builder += workFlagSwitch
        
        builder += SectionHeaderTitleFormItem().title("勤務時間")
        builder += beginTimePicker
        builder += endTimePicker
        builder += breakTimePicker
        builder += durationText
        builder += SectionHeaderTitleFormItem().title("備考")
        builder += remarkTextView
    }
    
    lazy var beginTimePicker: DatePickerFormItem = {
        let instance = DatePickerFormItem()
        instance.title = "開始時間"
        instance.datePickerMode = .time
        instance.minuteInterval = 30
        instance.behavior = .collapsed
        instance.valueDidChangeBlock = { [weak self] _ in
            //self?.updateSummary()
        }
        return instance
    }()
    
    lazy var endTimePicker: DatePickerFormItem = {
        let instance = DatePickerFormItem()
        instance.title = "終了時間"
        instance.datePickerMode = .time
        instance.minuteInterval = 30
        instance.behavior = .collapsed
        instance.valueDidChangeBlock = { [weak self] _ in
            //self?.updateSummary()
        }
        return instance
    }()
    
    lazy var workFlagSwitch: SwitchFormItem = {
        let instance = SwitchFormItem()
        instance.title = "作業日"
        instance.switchDidChangeBlock = { (value: Bool) in
            //
        }
        return instance
    }()
    
    lazy var breakTimePicker: DatePickerFormItem = {
        let instance = DatePickerFormItem()
        instance.title = "休憩時間"
        instance.datePickerMode = .time
        instance.behavior = .collapsed
        instance.minimumDate = Date(timeIntervalSince1970: 0)
        instance.minuteInterval = 30
        instance.valueDidChangeBlock = { [weak self] _ in
            //self?.updateSummary()
        }
        return instance
    }()
    
    lazy var durationText: StaticTextFormItem = {
        let instance = StaticTextFormItem()
        instance.title = "勤務時間"
        instance.value = "8.0"
        
        return instance
    }()
    
    lazy var remarkTextView: TextViewFormItem = {
        let instance = TextViewFormItem().placeholder("内容を入力してください。")
        return instance
    }()
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initControls()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //builder.navigationTitle = editDate.yearMonthDayString()
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

    // MARK: Actions
    @objc private func saveButtonTouched(_ sender: UIBarButtonItem) {
        print("saveButtonTouched!!")
        
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: Private
    private func initControls() {
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(DaySheetEditViewController.saveButtonTouched(_ :)))
        self.navigationItem.rightBarButtonItems = [saveButton]
    }
    
    
    
}
