//
//  PickerViewManager.swift
//  CoreApp
//
//  Created by CHEN YONGHAN on 2024/01/18.
//
import UIKit

// UIPickerViewDelegate、UIPickerViewDataSourceを適用するPickerViewManagerクラスを定義します
final class PickerViewManager: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    // ピッカービューを管理するためのプロパティ
    private var pickerView: UIPickerView?
    // ピッカービューのトリガーとなるテキストフィールド
    private var pickerViewTriggerField: UITextField!
    // ビューコントローラを保持するプロパティ
    private var viewController: UIViewController
    // ピッカービューに表示するデータの配列
    private var data: [[String]] = []
    // ピッカービューで選択された項目を処理するクロージャ
    private var selectionCompletion: (([String], [Int]) -> Void)?
    // デフォルトの選択インデックス
    private var defaultSelectionIndexes: [Int]?

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
    
    // デフォルトの選択インデックスを指定してピッカービューを表示するメソッド
    public func showPicker(with data: [[String]], defaultSelectionIndexes: [Int]? = nil, completion: @escaping ([String], [Int]) -> Void) {
        self.data = data
        self.selectionCompletion = completion
        self.defaultSelectionIndexes = defaultSelectionIndexes
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
        var selectedIndexes: [Int] = []
        for i in 0..<(pickerView?.numberOfComponents ?? 0) {
            let selectedRow = pickerView?.selectedRow(inComponent: i) ?? 0
            if i < data.count {
                selections.append(data[i][selectedRow])
                selectedIndexes.append(selectedRow)
            }
        }
        // 選択された項目を処理 - index　追加
        selectionCompletion?(selections, selectedIndexes)
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
