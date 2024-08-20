//
//  UIViewController+Extensions.swift
//  demoUtil
//
//  Created by 羽柴空 on 2024/07/12.
//

import Foundation

import Foundation
import UIKit
//import NautilusIdentifySDK
//import NautilusNotificationSDK

extension UIViewController {
    /// ポップアップ（確定ボタンあり）を表示します。
    ///
    /// - Parameters:
    ///   - title: ポップアップのタイトル
    ///   - message: ポップアップのメッセージ
    ///   - actionTitle: アクションボタンのタイトル
    ///   - actionHandler: アクションボタンがタップされた時の処理（オプショナル）
    ///
    public func showAlert(title: String, message: String, actionTitle: String, actionHandler: (() -> Void)?) {
        DispatchQueue.main.async {
            // アラートコントローラを作成する
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            // アクションボタンを作成して追加する
            let okAction = UIAlertAction(title: actionTitle, style: .default) { (action) in
                actionHandler?()
            }
            alertController.addAction(okAction)
            
            // 最前面のビューコントローラを取得するヘルパー関数
            func topViewController(_ rootViewController: UIViewController) -> UIViewController {
                if let presentedViewController = rootViewController.presentedViewController {
                    return topViewController(presentedViewController)
                }
                if let navigationController = rootViewController as? UINavigationController {
                    if let visibleViewController = navigationController.visibleViewController {
                        return topViewController(visibleViewController)
                    }
                }
                if let tabBarController = rootViewController as? UITabBarController {
                    if let selectedViewController = tabBarController.selectedViewController {
                        return topViewController(selectedViewController)
                    }
                }
                return rootViewController
            }
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let currentWindow = windowScene.windows.first,
               let rootViewController = currentWindow.rootViewController {
                let currentViewController = topViewController(rootViewController)
                // アラートを表示する
                currentViewController.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    /// ポップアップ（確定とキャンセルボタンあり）を表示します。
    ///
    /// - Parameters:
    ///   - title: ポップアップのタイトル
    ///   - message: ポップアップのメッセージ
    ///   - actionTitle: 確定ボタンのタイトル
    ///   - cancelTitle: キャンセルボタンのタイトル
    ///   - actionHandler: 確定ボタンがタップされた時の処理（オプショナル）
    public func showAlertWithCancel(title: String, message: String, actionTitle: String, cancelTitle: String, actionHandler: (() -> Void)?, cancelHandler: (() -> Void)?) {
        // アラートコントローラを作成する
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // アクションボタンを作成して追加する
        let okAction = UIAlertAction(title: actionTitle, style: .default) { (action) in
            actionHandler?()
        }
        alertController.addAction(okAction)
        
        // キャンセルボタンを作成して追加する
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { (action) in
            cancelHandler?()
        }
        alertController.addAction(cancelAction)
        
        // 現在のビューコントローラを取得してアラートを表示する
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let currentWindow = windowScene.windows.first,
           var currentViewController = currentWindow.rootViewController {
            
            // プレゼンテッドビューコントローラがある場合はそれを使う
            if let presentedViewController = currentViewController.presentedViewController {
                currentViewController = presentedViewController
            }
            
            // アラートを表示する
            currentViewController.present(alertController, animated: true, completion: nil)
        }
    }
    /// アラートメッセージを表示します（確認ボタンなし）。
    ///
    /// - Parameters:
    ///   - title: アラートのタイトル
    ///   - message: アラートのメッセージ内容
    ///   - duration: アラートの表示時間（秒）
    public func alertMessage(title: String, message: String, duration: Double) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // アラートを表示
        present(alertController, animated: true) {
            // 指定時間後にアラートを自動的に閉じる
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                alertController.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    
    
    /// 显示带有复制功能的弹窗，并在复制后执行一个操作
    ///
    /// - Parameters:
    ///   - title: 弹窗的标题
    ///   - message: 弹窗的消息
    ///   - textToCopy: 要复制的文本
    ///   - completion: 复制后要执行的操作
    public func showCopyAlert(title: String, message: String, textToCopy: String, completion: @escaping () -> Void) {
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        
        let textView = UITextView()
        textView.text = message
        textView.isEditable = false
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.isScrollEnabled = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        alertController.view.addSubview(textView)
        
        // Add constraints
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: alertController.view.topAnchor, constant: 45),
            textView.bottomAnchor.constraint(equalTo: alertController.view.bottomAnchor, constant: -45),
            textView.leadingAnchor.constraint(equalTo: alertController.view.leadingAnchor, constant: 15),
            textView.trailingAnchor.constraint(equalTo: alertController.view.trailingAnchor, constant: -15),
            textView.heightAnchor.constraint(equalToConstant: 500)
        ])
        
        // Add copy action
        let copyAction = UIAlertAction(title: "コピー", style: .default) { _ in
            UIPasteboard.general.string = textToCopy
            completion()
        }
        alertController.addAction(copyAction)
        
        // Add cancel action
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
//showCopyAlert(title: "注意", message: "これはコピー可能なテキストです。", textToCopy: "これはコピーされるテキストです。") {
//   // コピー後に実行する操作
//   print("テキストがコピーされました！")
//}
    
}



