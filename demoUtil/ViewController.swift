import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 创建一个垂直的 StackView
        let stackView = UIStackView()
        stackView.axis = .vertical  // 垂直排列
        stackView.distribution = .fillEqually  // 平均分布
        stackView.alignment = .center  // 居中对齐
        stackView.spacing = 20  // 按钮之间的间距
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(stackView)
        
        // 创建四个按钮
        let buttonTitles = ["A1", "A2", "A3", "A4"]
        let buttonWidth: CGFloat = 100
        let buttonHeight: CGFloat = 100
        
        for i in 0..<4 {
            let button = UIButton(type: .custom)
            button.frame = CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight)
            button.tag = i
            button.setImage(UIImage(named: buttonTitles[i]), for: .normal)
            button.addTarget(self, action: #selector(changeIcon(_:)), for: .touchUpInside)
            stackView.addArrangedSubview(button)
        }
        
        // 创建恢复默认图标的按钮
        let resetButton = UIButton(type: .system)
        resetButton.setTitle("クリアする", for: .normal)
        resetButton.addTarget(self, action: #selector(resetIcon), for: .touchUpInside)
        stackView.addArrangedSubview(resetButton)
        
        // 设置 StackView 的约束，使其在屏幕中央
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.widthAnchor.constraint(equalToConstant: buttonWidth),
        ])
    }

    // 切换图标的功能
    @objc func changeIcon(_ sender: UIButton) {
        print("图标已切换")
        let iconNames = ["AppIcon1", "AppIcon2", "AppIcon3", "AppIcon4"]
        let selectedIcon = iconNames[sender.tag]
        print(iconNames)
        print(selectedIcon)
        
        if UIApplication.shared.supportsAlternateIcons {
            UIApplication.shared.setAlternateIconName(selectedIcon) { error in
                if let error = error {
                    print("切换图标失败: \(error.localizedDescription)")
                } else {
                    print("图标已切换为: \(selectedIcon)")
                }
            }
        }
    }
    
    // 恢复默认图标
    @objc func resetIcon() {
        if UIApplication.shared.supportsAlternateIcons {
            UIApplication.shared.setAlternateIconName(nil) { error in
                if let error = error {
                    print("恢复图标失败: \(error.localizedDescription)")
                } else {
                    print("图标已恢复为默认")
                }
            }
        }
    }
}
