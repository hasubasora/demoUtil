
import UIKit

/// 性別選択マネージャークラス
///
/// 性別選択のためのピッカーを管理するクラスです。
/// ユーザーがテキストフィールドをタップするとピッカーが表示され、選択された性別がコールバックとして返されます。
final class GenderPickerManager {
    private weak var textField: UITextField?
    private weak var viewController: UIViewController?
    private var completion: ((String) -> Void)?
    private var pickerViewManager: PickerViewManager!

    /// 初期化メソッド
    ///
    /// - Parameters:
    ///   - viewController: 性別選択のための UIViewController
    ///   - textField: 性別を表示する UITextField
    ///   - completion: 性別選択後に呼ばれるコールバック
    init(viewController: UIViewController, textField: UITextField, completion: @escaping (String) -> Void) {
        self.viewController = viewController
        self.textField = textField
        self.completion = completion
        setupGenderPicker()
    }

    /// 性別ピッカーの設定
    private func setupGenderPicker() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showGenderPicker))
        textField?.addGestureRecognizer(tapGesture)
        textField?.isUserInteractionEnabled = true
    }

    /// 性別ピッカーを表示するメソッド
    @objc private func showGenderPicker() {
        guard let textField = textField, let viewController = viewController else { return }
        let data = [["男性", "女性", "その他"]]
        pickerViewManager = PickerViewManager(viewController: viewController)
        pickerViewManager.showPicker(with: data, defaultSelectionIndexes: [0]) { [weak self] selections,selectionIndex  in
            if let selectedString = selections.first {
                self?.completion?(selectedString)
            }
        }
    }
}


/**
使用方法
genderPickerManager = GenderPickerManager(viewController: self, textField: genderTextField) { [weak self] selectedGender in
    self?.genderTextField.text = selectedGender
    // 在选择性别后处理其他逻辑
}
 22222
 let genderTextField = UITextField()
 let viewController = UIViewController()

 let genderPickerManager = GenderPickerManager(viewController: viewController, textField: genderTextField) { selectedGender in
     print("Selected gender: \(selectedGender)")
 }

 
之前的使用方法

let genderTextFieldTapGesture = UITapGestureRecognizer(target: self, action: #selector(showGenderPicker))
genderTextField?.addGestureRecognizer(genderTextFieldTapGesture)
pickerViewManager = PickerViewManager(viewController: self)
 
 
@objc func showGenderPicker(completion: @escaping (String) -> Void) {
    let data = [["男性", "女性", "その他"]]
    pickerViewManager.showPicker(with: data, defaultSelectionIndexes: [0]) { [weak self] selections in
        guard let self = self else { return }
        if let selectedString = selections.first {
            completion(selectedString)
        }
    }
}
 

 */


//Random Key1: 22f43e3547917e21
//Random Key2: 89d91e4c2f35e493
//Combined Key: 89d91e4c2f35e49322f43e3547917e21
//Encrypted (Base64): rQxptWL/ra81XH7I8Jps2g==
