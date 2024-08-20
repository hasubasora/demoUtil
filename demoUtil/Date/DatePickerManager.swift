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
    private var pickerViewManager: PickerViewManager!
    private var dayTapGesture: UITapGestureRecognizer?
    let year25YearsAgo = getYear25YearsAgo()

    var onDateSelected: (([String]) -> Void)?
    /// 初期化メソッド
    ///
    /// - Parameters:
    ///   - viewController: 管理するビューコントローラ
    ///   - yearTextField: 年の入力フィールド
    ///   - monthTextField: 月の入力フィールド
    ///   - dayTextField: 日の入力フィールド
    init(viewController: UIViewController, yearTextField: UITextField, monthTextField: UITextField, dayTextField: UITextField) {
        self.viewController = viewController
        self.birthYearTextField = yearTextField
        self.birthMonthTextField = monthTextField
        self.birthDayTextField = dayTextField
        super.init()
        setup()
    }
    
    /// 初期設定を行うメソッド
    private func setup() {
        guard let viewController = viewController else { return }
        pickerViewManager = PickerViewManager(viewController: viewController)
        
        let yearTapGesture = UITapGestureRecognizer(target: self, action: #selector(yearTextFieldTapped))
        birthYearTextField?.addGestureRecognizer(yearTapGesture)
        
        let monthTapGesture = UITapGestureRecognizer(target: self, action: #selector(monthTextFieldTapped))
        birthMonthTextField?.addGestureRecognizer(monthTapGesture)
        
        let dayTextFieldGesture = UITapGestureRecognizer(target: self, action: #selector(dayTextFieldTapped))
        birthDayTextField?.addGestureRecognizer(dayTextFieldGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        viewController.view.addGestureRecognizer(tapGesture)
    }
    /// キーボードを閉じるメソッド
    @objc private func dismissKeyboard() {
        viewController?.view.endEditing(true)
    }
    
    /// 年のテキストフィールドがタップされた時の処理
    ///
    /// 年月日の処理には必ず西暦（グレゴリオ暦）を使用してください
    @objc private func yearTextFieldTapped() {
        let yearsArray = getYearsArray()
        if let indexOfYear = getIndexOfYear(getYear25YearsAgo(), in: yearsArray) {
            pickerViewManager.showPicker(with: [yearsArray], defaultSelectionIndexes: [indexOfYear]) { [weak self] selections,selectionIndex  in
                guard let self = self else { return }
                self.birthYearTextField?.text = selections[0]
                self.textFieldDidEndEditing(self.birthYearTextField)
                if let selectedYear = selections.first, selectedYear == String(Calendar(identifier: .gregorian).component(.year, from: Date())) {
                    self.birthMonthTextField?.text = ""
                }
            }
        }
    }
    
    /// 月のテキストフィールドがタップされた時の処理
    ///
    /// 年月日の処理には必ず西暦（グレゴリオ暦）を使用してください
    @objc private func monthTextFieldTapped() {
        let yearTextFieldText = birthYearTextField?.text ?? ""
        let yearToUse = yearTextFieldText.isEmpty ? getYear25YearsAgo() : yearTextFieldText
        let monthsArray = getMonthsArray(for: yearToUse)
        pickerViewManager.showPicker(with: [monthsArray], defaultSelectionIndexes: [0]) { [weak self] selections,selectionIndex  in
            guard let self = self else { return }
            self.birthMonthTextField?.text = selections[0]
            self.textFieldDidEndEditing(self.birthMonthTextField)
            self.birthDayTextField?.text = ""
        }
    }
    
    /// 日のテキストフィールドがタップされた時の処理
    ///
    /// 年月日の処理には必ず西暦（グレゴリオ暦）を使用してください
    @objc private func dayTextFieldTapped() {
        guard let year = birthYearTextField?.text, let month = birthMonthTextField?.text else { return }
        let daysArray = getDaysArray(year: year, month: month)
        pickerViewManager.showPicker(with: [daysArray], defaultSelectionIndexes: [0]) { [weak self] selections,selectionIndex  in
            guard let self = self else { return }
            self.birthDayTextField?.text = selections[0]
            let dateArray = self.assembleDateArray()
            self.onDateSelected?(dateArray) // Call the closure with the date array
        }
    }
    
    /// 日のテキストフィールドのタップジェスチャーを更新します
    ///
    /// 年月日の処理には必ず西暦（グレゴリオ暦）を使用してください
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
    
    /// テキストフィールドの編集が終了した時の処理
    private func textFieldDidEndEditing(_ textField: UITextField?) {
        if textField == birthYearTextField || textField == birthMonthTextField {
            updateDayTextFieldTapGesture()
        }
    }
    
    /// 年月日を配列として取得します
    ///
    /// - Returns: 年月日の配列
    ///
    /// 年月日の処理には必ず西暦（グレゴリオ暦）を使用してください
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
