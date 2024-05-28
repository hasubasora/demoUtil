//
//  PickerUtil.swift
//  demoUtil
//
//  Created by 羽柴空 on 2024/05/21.
//
import UIKit

// PickerUtil、UIPickerViewDataSourceを適用するPickerViewManagerクラスを定義します
final class PickerUtil: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    // ピッカービューを管理するためのプロパティ
    private var pickerView: UIPickerView?
    // ピッカービューのトリガーとなるテキストフィールド
    private var pickerViewTriggerField: UITextField!
    // ビューコントローラを保持するプロパティ
    private var viewController: UIViewController
    // ピッカービューに表示するデータの配列
    private var data: [[String]] = []
    // ピッカービューで選択された項目を処理するクロージャ
    private var selectionCompletion: (([String]) -> Void)?

    // 初期化
    init(viewController: UIViewController) {
        self.viewController = viewController
        super.init()
        
        // ピッカービューをセットアップするメソッドを呼び出す
        setupPickerView()
    }
    
    // ピッカービューをセットアップするメソッド
    private func setupPickerView() {
        // UIPickerViewのインスタンスを作成
        pickerView = UIPickerView()
        pickerViewTriggerField = UITextField()
        pickerView?.delegate = self
        pickerView?.dataSource = self
        pickerViewTriggerField.isHidden = true
        viewController.view.addSubview(pickerViewTriggerField)
        
        // ピッカートリガーフィールドの入力ビューとしてピッカービューを設定
        pickerViewTriggerField.inputView = pickerView
        
        // ツールバーを作成
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissPicker))
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
        toolbar.setItems([cancelButton, flexibleSpace, doneButton], animated: false)
        pickerViewTriggerField.inputAccessoryView = toolbar
    }
    
    // ピッカービューを表示するメソッド
   public func showPicker(with data: [[String]], completion: @escaping ([String]) -> Void) {
        self.data = data
        self.selectionCompletion = completion
        pickerView?.reloadAllComponents()
        pickerViewTriggerField.becomeFirstResponder()
    }
    
    // デフォルトの選択インデックスを指定してピッカービューを表示するメソッド
    public func showPicker(with data: [[String]], defaultSelectionIndexes: [Int]? = nil, completion: @escaping ([String]) -> Void) {
        self.data = data
        self.selectionCompletion = completion
        // ピッカービューをリロード
        pickerView?.reloadAllComponents()

        if let indexes = defaultSelectionIndexes {
            for (component, rowIndex) in indexes.enumerated() {
                pickerView?.selectRow(rowIndex, inComponent: component, animated: false)
            }
        }
        // ピッカービューを表示
        pickerViewTriggerField.becomeFirstResponder()
    }

    // キャンセルボタンがタップされた時の処理
    @objc private func cancelButtonTapped() {
        pickerViewTriggerField.resignFirstResponder()
    }
    // ピッカービューを閉じる処理
    @objc private func dismissPicker() {
        // ピッカービューを閉じる
        pickerViewTriggerField.resignFirstResponder()
        var selections: [String] = []
        for i in 0..<(pickerView?.numberOfComponents ?? 0) {
            let selectedRow = pickerView?.selectedRow(inComponent: i) ?? 0
            if i < data.count {
                selections.append(data[i][selectedRow])
            }
        }
        // 選択された項目を処理
        selectionCompletion?(selections)
    }
    // ピッカービューのコンポーネント数を返すメソッド
    internal func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return data.count
    }
    // 指定されたコンポーネントの行数を返すメソッド
    internal func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data[component].count
    }
    // 指定されたコンポーネントと行のタイトルを返すメソッド
    internal func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[component][row]
    }
}

/*
 //使用方法
 private var pickerViewManager: PickerViewManager!
 
 //声明创建这个类
 let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
 view.addGestureRecognizer(tapGesture)
 pickerViewManager = PickerViewManager(viewController: self)
 
 //关闭选择框
 @objc func dismissKeyboard() {
     view.endEditing(true)
 }
 
 使用方法
 yearsArray 是单数组
 使用需要双重数组
 defaultSelectionIndexes是默认打开的第几个
 
 pickerViewManager.showPicker(with: [yearsArray], defaultSelectionIndexes: [indexOfYear]) { [weak self] selections in
     guard let self = self else { return }
     self.yearTextField.text = selections[0]
     textFieldDidEndEditing(yearTextField)
     // 現在の年が選択された場合、月フィールドをクリアする
     if let selectedYear = selections.first, selectedYear == String(Calendar.current.component(.year, from: Date())) {
         self.monthTextField.text = ""
     }
 }
 */
