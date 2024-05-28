//
//  yearMonthDaysUtil.swift
//  CoreApp
//
//  Created by 羽柴空 on 2024/05/23.
//

import Foundation

import UIKit

class DatePickerManager: NSObject {
    private weak var viewController: UIViewController?
    private weak var birthYearTextField: UITextField?
    private weak var birthMonthTextField: UITextField?
    private weak var birthDayTextField: UITextField?
    private var pickerViewManager: PickerUtil!
    private var dayTapGesture: UITapGestureRecognizer?
    let year25YearsAgo = getYear25YearsAgo()

    var onDateSelected: (([String]) -> Void)?

    init(viewController: UIViewController, yearTextField: UITextField, monthTextField: UITextField, dayTextField: UITextField) {
        self.viewController = viewController
        self.birthYearTextField = yearTextField
        self.birthMonthTextField = monthTextField
        self.birthDayTextField = dayTextField
        super.init()
        setup()
    }

    private func setup() {
        guard let viewController = viewController else { return }
        pickerViewManager = PickerUtil(viewController: viewController)
        
        let yearTapGesture = UITapGestureRecognizer(target: self, action: #selector(yearTextFieldTapped))
        birthYearTextField?.addGestureRecognizer(yearTapGesture)
        
        let monthTapGesture = UITapGestureRecognizer(target: self, action: #selector(monthTextFieldTapped))
        birthMonthTextField?.addGestureRecognizer(monthTapGesture)
        
        let dayTextFieldGesture = UITapGestureRecognizer(target: self, action: #selector(dayTextFieldTapped))
        birthDayTextField?.addGestureRecognizer(dayTextFieldGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        viewController.view.addGestureRecognizer(tapGesture)
    }

    @objc private func dismissKeyboard() {
        viewController?.view.endEditing(true)
    }

    @objc private func yearTextFieldTapped() {
        let yearsArray = getYearsArray()
        if let indexOfYear = getIndexOfYear(getYear25YearsAgo(), in: yearsArray) {
            pickerViewManager.showPicker(with: [yearsArray], defaultSelectionIndexes: [indexOfYear]) { [weak self] selections in
                guard let self = self else { return }
                self.birthYearTextField?.text = selections[0]
                self.textFieldDidEndEditing(self.birthYearTextField)
                if let selectedYear = selections.first, selectedYear == String(Calendar.current.component(.year, from: Date())) {
                    self.birthMonthTextField?.text = ""
                }
            }
        }
    }

    @objc private func monthTextFieldTapped() {
        let yearTextFieldText = birthYearTextField?.text ?? ""
        let yearToUse = yearTextFieldText.isEmpty ? getYear25YearsAgo() : yearTextFieldText
        let monthsArray = getMonthsArray(for: yearToUse)
        pickerViewManager.showPicker(with: [monthsArray], defaultSelectionIndexes: [0]) { [weak self] selections in
            guard let self = self else { return }
            self.birthMonthTextField?.text = selections[0]
            self.textFieldDidEndEditing(self.birthMonthTextField)
            self.birthDayTextField?.text = ""
        }
    }

    @objc private func dayTextFieldTapped() {
        guard let year = birthYearTextField?.text, let month = birthMonthTextField?.text else { return }
        let daysArray = getDaysArray(year: year, month: month)
        pickerViewManager.showPicker(with: [daysArray], defaultSelectionIndexes: [0]) { [weak self] selections in
            guard let self = self else { return }
            self.birthDayTextField?.text = selections[0]
            let dateArray = self.assembleDateArray()
            self.onDateSelected?(dateArray) // Call the closure with the date array
        }
    }

    private func updateDayTextFieldTapGesture() {
        if let yearText = birthYearTextField?.text, !yearText.isEmpty,
           let monthText = birthMonthTextField?.text, !monthText.isEmpty {
            if dayTapGesture == nil {
                dayTapGesture = UITapGestureRecognizer(target: self, action: #selector(dayTextFieldTapped))
                birthDayTextField?.addGestureRecognizer(dayTapGesture!)
            }
        } else {
            if let gestureRecognizers = birthDayTextField?.gestureRecognizers {
                for recognizer in gestureRecognizers {
                    birthDayTextField?.isEnabled = true
                    birthDayTextField?.removeGestureRecognizer(recognizer)
                }
            }
            dayTapGesture = nil
        }
    }

    private func textFieldDidEndEditing(_ textField: UITextField?) {
        if textField == birthYearTextField || textField == birthMonthTextField {
            updateDayTextFieldTapGesture()
        }
    }

    func assembleDateArray() -> [String] {
        let year = birthYearTextField?.text ?? ""
        let month = birthMonthTextField?.text ?? ""
        let day = birthDayTextField?.text ?? ""
        return [year, month, day]
    }
}


/**
 
 需要文件：
 PickerUtil  滑动选择窗口创建
 DateComponentsUtil 获取年月日 精确到当天 默认设定当年-25年
 
 然后调用以下方法：
 需要配置
 @IBOutlet weak var birthYearTextField: UITextField!
 @IBOutlet weak var birthMonthTextField: UITextField!
 @IBOutlet weak var birthDayTextField: UITextField!
 
 声明
 private var datePickerManager: DatePickerManager!

 加载的时候调用的方法
 datePickerManager = DatePickerManager(viewController: self, yearTextField: birthYearTextField, monthTextField: birthMonthTextField, dayTextField: birthDayTextField)
 datePickerManager.onDateSelected = { [weak self] dateArray in
     guard let self = self else { return }
     print("Selected date array: \(dateArray)")
     // 你可以在这里处理返回的日期数组
 }
 
 */
