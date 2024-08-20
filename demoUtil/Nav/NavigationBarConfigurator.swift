
import UIKit

/// ナビゲーションバーのアクションに関連するメソッドを定義するプロトコル。
///
/// ナビゲーションバーのボタンアクションを扱うためのメソッドを定義します。
@objc protocol NavigationBarActions {
    /// 左側のボタンがタップされたときに呼び出されるメソッド
    /// - 注意: オプショナルなメソッドとして定義されています。
    @objc optional func LeftButtonTapped()
    
    /// 右側のボタンがタップされたときに呼び出されるメソッド
    /// - 注意: オプショナルなメソッドとして定義されています。
    @objc optional func rightButtonTapped()
}

/// ナビゲーションバーの設定を行う構造体。
///
/// ナビゲーションバーのスタイルとその内容を設定するための構造体です。
struct NavigationBarConfigurator {
    /// ナビゲーションバーのスタイルを定義する列挙型。
    enum NavigationBarStyle {
        case basic(center: TitleContent)
        case withBackButton(center: TitleContent, right: TitleContent?)
        case withTwoButtons(center: TitleContent, rightFirst: TitleContent?, rightSecond: TitleContent?)
        case withRightButton(center: TitleContent, right: TitleContent)
        /// タイトルのコンテンツを定義する列挙型。
        enum TitleContent {
            case text(String)
            case image(UIImage)
        }
    }

    /// ナビゲーションバーを設定するメソッド
    ///
    /// - Parameters:
    ///   - viewController: ナビゲーションバーを設定する対象のビューコントローラ
    ///   - style: 設定するナビゲーションバースタイル
    static func setupNavigationBar(for viewController: UIViewController & NavigationBarActions, style: NavigationBarStyle) {
        guard let navigationController = viewController.navigationController else { return }

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        navigationController.navigationBar.standardAppearance = appearance
        navigationController.navigationBar.scrollEdgeAppearance = appearance
        navigationController.navigationBar.tintColor = .black

        switch style {
        case .basic(let center):
            viewController.navigationItem.titleView = createTitleView(content: center)

        case .withBackButton(let center, let right):
            viewController.navigationItem.titleView = createTitleView(content: center)
            if let rightContent = right {
                viewController.navigationItem.rightBarButtonItem = createBarButtonItem(content: rightContent, for: viewController)
            }
            viewController.navigationItem.leftBarButtonItem = createBackButton(for: viewController)

        case .withTwoButtons(let center, let rightFirst, let rightSecond):
            viewController.navigationItem.titleView = createTitleView(content: center)
            viewController.navigationItem.leftBarButtonItem = createBackButton(for: viewController)
            var rightBarButtons = [UIBarButtonItem]()
            if let rightContent = rightFirst {
                rightBarButtons.append(createBarButtonItem(content: rightContent, for: viewController))
            }
            if let secondRightContent = rightSecond {
                rightBarButtons.append(createBarButtonItem(content: secondRightContent, for: viewController))
            }
            viewController.navigationItem.rightBarButtonItems = rightBarButtons

        case .withRightButton(let center, let right):
            viewController.navigationItem.titleView = createTitleView(content: center)
            viewController.navigationItem.rightBarButtonItem = createBarButtonItem(content: right, for: viewController)
        }
    }

    /// ナビゲーションバーのタイトルビューを作成するメソッド
    ///
    /// - Parameter content: タイトルの内容（テキストまたは画像）
    /// - Returns: 作成されたタイトルビュー
    private static func createTitleView(content: NavigationBarStyle.TitleContent) -> UIView {
        switch content {
        case .text(let text):
            let titleLabel = UILabel()
            titleLabel.text = text
            titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
            titleLabel.textColor = .black
            titleLabel.sizeToFit()
            return titleLabel
        case .image(let image):
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            return imageView
        }
    }

    /// ナビゲーションバーのボタンを作成するメソッド
    ///
    /// - Parameters:
    ///   - content: ボタンの内容（テキストまたは画像）
    ///   - viewController: ボタンのターゲットとなるビューコントローラ
    /// - Returns: 作成されたバー ボタン アイテム
    private static func createBarButtonItem(content: NavigationBarStyle.TitleContent, for viewController: UIViewController & NavigationBarActions) -> UIBarButtonItem {
        switch content {
        case .text(let text):
            return UIBarButtonItem(title: text, style: .plain, target: viewController, action: #selector(NavigationBarActions.rightButtonTapped))
        case .image(let image):
            return UIBarButtonItem(image: image, style: .plain, target: viewController, action: #selector(NavigationBarActions.rightButtonTapped))
        }
    }

    /// ナビゲーションバーの戻るボタンを作成するメソッド
    ///
    /// - Parameter viewController: ボタンのターゲットとなるビューコントローラ
    /// - Returns: 作成された戻るボタン
    private static func createBackButton(for viewController: UIViewController & NavigationBarActions) -> UIBarButtonItem {
        return UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: viewController, action: #selector(NavigationBarActions.LeftButtonTapped))
    }
}



/**
 
 使用方法
 NavigationBarConfigurator.setupNavigationBar(for: self, style: .basic(center: .text(“1111”)))
 NavigationBarConfigurator.setupNavigationBar(for: self, style: .withBackButton(center: .text(“11111”), right: nil))
 NavigationBarConfigurator.setupNavigationBar(for: self, style: .withBackButton(center: .text("11111"), right: .text("Right Button")))
 NavigationBarConfigurator.setupNavigationBar(for: self, style: .withTwoButtons(center: .text("11111"), rightFirst: .text("Right 1"), rightSecond: .text("Right 2")))
 
 let rightButtonImage = UIImage(systemName: "xmark")! // ここに適切な画像名を設定
 NavigationBarConfigurator.setupNavigationBar(for: self, style: .withRightButton(center: .text("マイページ"), right: .image(rightButtonImage)))
 
 if let image = UIImage(named: "logo"), let rightButtonImage1 = UIImage(systemName: "plus"), let rightButtonImage2 = UIImage(systemName: "gear") {
 NavigationBarConfigurator.setupNavigationBar(for: self, style: .withTwoButtons(center: .image(image), rightFirst: .image(rightButtonImage1), rightSecond: .image(rightButtonImage2)))
 }
 
 
 let storyboard = UIStoryboard(name: "MemberInfoInput", bundle: nil)
 let viewController = storyboard.instantiateViewController(withIdentifier: "MemberInfoInput")
 let navController = UINavigationController(rootViewController: viewController)
 navController.modalPresentationStyle = .fullScreen
 self.present(navController, animated: true, completion: nil)
 


 
// 配置导航栏为基本样式
NavigationBarConfigurator.setupNavigationBar(
    for: self,
    style: .basic(center: .text("Basic Title"))
)
 // 配置导航栏为基本样式，标题为图片
 NavigationBarConfigurator.setupNavigationBar(
     for: self,
     style: .basic(center: .image(UIImage(systemName: "star")!))
 )
 
// 配置导航栏为带返回按钮样式，标题为文本，右侧按钮为文本
NavigationBarConfigurator.setupNavigationBar(
    for: self,
    style: .withBackButton(
        center: .text("Back Button Title"),
        right: .text("Action")
    )
)
// 配置导航栏为带返回按钮样式，标题为文本，右侧按钮为图片
NavigationBarConfigurator.setupNavigationBar(
    for: self,
    style: .withBackButton(
        center: .text("Back Button Title"),
        right: .image(UIImage(systemName: "star")!)
    )
)
// 配置导航栏为带两个按钮样式，标题为文本，右侧按钮为文本和图片
NavigationBarConfigurator.setupNavigationBar(
    for: self,
    style: .withTwoButtons(
        center: .text("Two Buttons Title"),
        rightFirst: .text("First Action"),
        rightSecond: .image(UIImage(systemName: "gear")!)
    )
)
 */
