
import UIKit

// メソッドをカプセル化するために拡張を追加
extension UITextField {
    func configurePasswordToggle() {
        let eyeButton = UIButton(type: .system)
        configureEyeButton(eyeButton: eyeButton)
        
        // ボタンをテキストフィールドの右側に配置
        rightView = eyeButton
        rightViewMode = .always
        isSecureTextEntry = true
        textContentType = .oneTimeCode
    }
    
    private func configureEyeButton(eyeButton: UIButton) {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "eye.slash")?.withTintColor(.gray, renderingMode: .alwaysOriginal)
        config.imagePadding = 5
        config.baseForegroundColor = .gray
        config.background = UIBackgroundConfiguration.clear()

        eyeButton.configuration = config
        eyeButton.addTarget(self, action: #selector(togglePasswordVisibility(sender:)), for: .touchUpInside)
    }
    
    @objc private func togglePasswordVisibility(sender: UIButton) {
        isSecureTextEntry.toggle()
        let imageName = isSecureTextEntry ? "eye.slash" : "eye"
        var config = sender.configuration
        config?.image = UIImage(systemName: imageName)?.withTintColor(.gray, renderingMode: .alwaysOriginal)
        sender.configuration = config
    }
}

/**
 使用方法
 newPasswordTextField.configurePasswordToggle()
 
 */

// 各 UITextField に小さな三角形ボタンを追加
func addDropdownImage(to textField: UITextField) {
    let dropdownImage = UIImageView(image: UIImage(named: "ma_ui_dropdown_expand"))
    dropdownImage.frame = CGRect(x: 0, y: 0, width: 12, height: 12)
    dropdownImage.contentMode = .scaleAspectFit
    
    // パディングビューを画像のサイズより大きくする
    let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
    dropdownImage.center = paddingView.center
    paddingView.addSubview(dropdownImage)
    
    textField.rightView = paddingView
    textField.rightViewMode = .always
}

/**
 使用方法
 addDropdownImage(to: yearTextField)

 */


