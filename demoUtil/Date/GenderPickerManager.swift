
import UIKit

class GenderPickerManager {
    private weak var textField: UITextField?
    private weak var viewController: UIViewController?
    private var completion: ((String) -> Void)?
    private var pickerViewManager: PickerUtil!

    init(viewController: UIViewController, textField: UITextField, completion: @escaping (String) -> Void) {
        self.viewController = viewController
        self.textField = textField
        self.completion = completion
        setupGenderPicker()
    }

    private func setupGenderPicker() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showGenderPicker))
        textField?.addGestureRecognizer(tapGesture)
        textField?.isUserInteractionEnabled = true

    }

    @objc private func showGenderPicker() {
        guard let textField = textField, let viewController = viewController else { return }
        let data = [["男性", "女性", "その他"]]
        pickerViewManager = PickerUtil(viewController: viewController)
        pickerViewManager.showPicker(with: data, defaultSelectionIndexes: [0]) { [weak self] selections in
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
