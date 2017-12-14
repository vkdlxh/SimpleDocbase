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

    internal var worksheetItem : WorkSheetItem?
    let workSheetmanager = WorkSheetManager.sharedManager
    var yearMonth: String = ""
    var sheetItems: [WorkSheetItem]?
    var intervalTime: Int = 30
    
    override func populate(_ builder: FormBuilder) {
        getIntervalTime()
        if let year = worksheetItem?.workYear, let month = worksheetItem?.workMonth, let day = worksheetItem?.workDay  {
            builder.navigationTitle = String(format: "%04d.%02d.%02d", year, month, day)
        }
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
        instance.minuteInterval = intervalTime
        instance.locale = Locale(identifier: "en_GB")
        instance.behavior = .collapsed
        
        if let begin_time = worksheetItem?.beginTime {
            instance.setValue(begin_time, animated: false)
        }else {
            if let time = Date.createTime(hour: 9, minute: 0) {
                instance.setValue(time, animated: false)
            }
        }
        
        instance.valueDidChangeBlock = { [weak self] _ in
            self?.updateDuration()
        }
        return instance
    }()
    
    lazy var endTimePicker: DatePickerFormItem = {
        let instance = DatePickerFormItem()
        instance.title = "終了時間"
        instance.datePickerMode = .time
        instance.minuteInterval = intervalTime
        instance.locale = Locale(identifier: "en_GB")
        instance.behavior = .collapsed
        
        if let end_time = worksheetItem?.endTime {
            instance.setValue(end_time, animated: false)
        }else {
            if let time = Date.createTime(hour: 9, minute: 0) {
                instance.setValue(time, animated: false)
            }
        }
        
        instance.valueDidChangeBlock = { [weak self] _ in
            self?.updateDuration()
        }
        return instance
    }()
    
    lazy var workFlagSwitch: SwitchFormItem = {
        let instance = SwitchFormItem()
        instance.title = "作業日"
        
        if let flag = worksheetItem?.workFlag {
            instance.value = flag
        }
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
        instance.minuteInterval = intervalTime
        instance.locale = Locale(identifier: "en_GB")
        
        if let break_time = worksheetItem?.breakTime {
            let hour = Int(floor(break_time))
            let minute = Int((break_time - Double(hour)) * 60)    //0.5 ->30min
            
            if let time = Date.createTime(hour: hour, minute: minute) {
                instance.setValue(time, animated: false)
            }
        }else {
            if let time = Date.createTime(hour: 1, minute: 0) {
                instance.setValue(time, animated: false)
            }
        }
        
        instance.valueDidChangeBlock = { [weak self] _ in
            self?.updateDuration()
        }
        return instance
    }()
    
    lazy var durationText: StaticTextFormItem = {
        let instance = StaticTextFormItem()
        instance.title = "勤務時間"
        
//        let calendar = NSCalendar.current
//
//        guard let begin_time = worksheetItem?.beginTime else {
//            return instance
//        }
//
//        guard let end_tiem = worksheetItem?.endTime else {
//            return instance
//        }
//
//        let comps = calendar.dateComponents([.hour, .minute], from: begin_time, to: end_tiem)
//
//        guard let hour = comps.hour else {
//            return instance
//        }
//        guard let minute = comps.minute else {
//            return instance
//        }
//
//        let duration = (Double(hour) + Double(minute/60)) - (worksheetItem?.breakTime ?? 0)
//        instance.value = String(format:"%.2f",duration)
        guard let duration = worksheetItem?.duration else {
            return instance
        }
        instance.value = String(format:"%.2f", duration)
        
        return instance
    }()
    
    lazy var remarkTextView: TextViewFormItem = {
        let instance = TextViewFormItem().placeholder("内容を入力してください。")
        if let remark = worksheetItem?.remark {
            instance.value = remark
        }
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
        
        print("\n\(workFlagSwitch.value),\n\(beginTimePicker.value.hourMinuteString()),\n\(endTimePicker.value.hourMinuteString()),\n\(breakTimePicker.value.hourMinuteString()),\n\(durationText.value),\n\(remarkTextView.value)")
        
        //update worksheet item
        worksheetItem?.workFlag = workFlagSwitch.value
        worksheetItem?.beginTime = beginTimePicker.value
        worksheetItem?.endTime = endTimePicker.value
        worksheetItem?.breakTime = breakTimePicker.value.duration()
        worksheetItem?.remark = remarkTextView.value
        worksheetItem?.duration = Double(durationText.value)
        
        print(worksheetItem)
        
        //TODO: 保存処理をする
        //保存処理を実装してください。
        if let worksheetItem = worksheetItem {
            if var sheetItems = sheetItems {
                sheetItems.append(worksheetItem)
                workSheetmanager.saveSheetItem(yearMonth: yearMonth, sheetItems: sheetItems)
            }
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: Private
    private func initControls() {
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(DaySheetEditViewController.saveButtonTouched(_ :)))
        self.navigationItem.rightBarButtonItems = [saveButton]
    }
    
    private func updateDuration() {
        
        let calendar = NSCalendar.current
        
        let comps = calendar.dateComponents([.hour, .minute], from: beginTimePicker.value, to: endTimePicker.value)
        
        guard let hour = comps.hour else {
            return
        }
        guard let minute = comps.minute else {
            return
        }
        
        let breakTime = getBreakTimeFormDate(date: breakTimePicker.value)
        
        let duration = (Double(hour) + Double(minute/60)) - breakTime
        durationText.value = String(format:"%.2f",duration)
    }
    
    private func getIntervalTime() {
        if let intervalTime = UserDefaults.standard.object(forKey: "minuteInterval") as? String {
            self.intervalTime = Int(intervalTime)!
        }
    }
    
    private func getBreakTimeFormDate(date: Date) -> Double {
        let zeroDate = Date.createTime(hour: 0, minute: 0)
        let calendar = NSCalendar.current
        let comps = calendar.dateComponents([.hour, .minute], from: zeroDate!, to: date)
        
        guard let hour = comps.hour else {
            return 0
        }
        guard let minute = comps.minute else {
            return 0
        }
        return Double(hour) + Double(minute/60)
    }
    
}
