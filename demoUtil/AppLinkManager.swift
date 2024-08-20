//
//  LinkHandler.swift
//  CoreApp
//
//  Created by CHEN YONGHAN on 2024/1/3.
//
import Foundation
import StoreKit

#if canImport(NautilusAnalyticsSDK)
import NautilusUISDK
import NautilusAnalyticsSDK
private var analytics: NautilusAnalytics {
    NautilusAnalytics.analytics()
}
#endif

/// `AppLinkManager` クラス
///
/// このクラスは、アプリリンクの管理を行います。リンクがタップされた時の処理、App Store ページの表示、特定のアプリがインストールされているかどうかの確認を行います。
public class AppLinkManager {

    /// リンクがタップされた時の処理
    ///
    /// - Parameters:
    ///   - appURLScheme: アプリのURLスキーム
    ///   - appID: アプリのID
    public func linkTapped(to appURLScheme: String, appID: String) {
        if let url = URL(string: appURLScheme) {
            UIApplication.shared.open(url, options: [:]) { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    if UIApplication.shared.applicationState == .active {
                        self.openAppStorePage(appID: appID)
                        return
                    }
                }
            }
        }
    }

    /// App Storeページを開く処理
    ///
    /// - Parameter appID: アプリのID
    public func openAppStorePage(appID: String) {
        let storeViewController = SKStoreProductViewController()
        storeViewController.delegate = nil
        let parameters = [SKStoreProductParameterITunesItemIdentifier: NSNumber(value: Int(appID) ?? 0)]
        storeViewController.loadProduct(withParameters: parameters) { success, error in
            if success {
                if let windowScene = UIApplication.shared.connectedScenes
                    .compactMap({ $0 as? UIWindowScene })
                    .first(where: { $0.activationState == .foregroundActive }),
                   let window = windowScene.windows.first {
                    window.rootViewController?.present(storeViewController, animated: true, completion: nil)
                }
            } else {
//                showAlert(title: "エラー", message: "通信に失敗しました。通信状況をご確認ください", actionTitle: "OK") {}
            }
        }
    }

    /// 特定のアプリケーションがインストールされているかどうかを確認するメソッド
    ///
    /// - Parameter appURLScheme: アプリのURLスキーム
    /// - Returns: アプリがインストールされている場合は `true`、それ以外の場合は `false`
    public func isAppInstalled(appURLScheme: String) -> Bool {
        guard let appURL = URL(string: "\(appURLScheme)://") else { return false }
        return UIApplication.shared.canOpenURL(appURL)
    }
}


//let appLinkManager = AppLinkManager()
//
//// line
//func line(){
//    let appID = "443904275"
//    let appURLScheme = "jp.chatapp"
//    appLinkManager.linkTapped(to: appURLScheme, appID: appID)
//}
//// dpoint
//public func dpoint()  {
//    #if canImport(NautilusAnalyticsSDK)
//    /// dポイントアプリへ遷移する
//    analytics.sendEvent(event: .TapDPointApp)
//    #endif
//    let appID = "821434357"
//    let appURLScheme = "com.nttdocomo.dpoint.start://"
//    appLinkManager.linkTapped(to: appURLScheme, appID: appID)
//}
//
//// Instagram
//public func instagram()  {
//    let appID = "389801252"
//    let hokuyuLucky = "hokuyu_lucky"
//    let appURLScheme = "Instagram://user?username=\(hokuyuLucky)"
//    appLinkManager.linkTapped(to: appURLScheme, appID: appID)
//}
//public func instagramSelectionHeadoffice()  {
//    let appID = "389801252"
//    let selection_headoffice = "selection_headoffice"
//    let appURLScheme = "Instagram://user?username=\(selection_headoffice)"
//    appLinkManager.linkTapped(to: appURLScheme, appID: appID)
//}
//
//// wolt-app
//func wolt() {
//    let appID = "943905271"
//    let appURLScheme = "wolt-app"
//    appLinkManager.linkTapped(to: appURLScheme, appID: appID)
//}

// アプリがインストールされているかどうかを確認する
//let isInstalled = appLinkManager.isAppInstalled(appURLScheme: "appScheme")
//print("Is app installed: \(isInstalled)")

