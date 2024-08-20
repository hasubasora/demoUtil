
import Foundation
import StoreKit

#if canImport(NautilusAnalyticsSDK)
import NautilusUISDK
import NautilusAnalyticsSDK
private var analytics: NautilusAnalytics {
    NautilusAnalytics.analytics()
}
#endif
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
                    openAppStorePage(appID: appID)
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
            //alert
        }
    }
}

// 特定のアプリケーションがインストールされているかどうかを確認するための新しい機能を追加しました
func isAppInstalled(appURLScheme: String) -> Bool {
    guard let appURL = URL(string: "\(appURLScheme)://") else { return false }
    return UIApplication.shared.canOpenURL(appURL)
}
/**
 方法
 let appURLScheme = "line"
 if isAppInstalled(appURLScheme: appURLScheme) {
    
    } else {
    
 }
 */


// line
func line(){
    let appID = "443904275"
    let appURLScheme = "jp.chatapp"
    linkTapped(to: appURLScheme, appID: appID)
}
// dpoint
public func dpoint()  {
    #if canImport(NautilusAnalyticsSDK)
    /// dポイントアプリへ遷移する
    analytics.sendEvent(event: .TapDPointApp)
    #endif
    let appID = "821434357"
    let appURLScheme = "com.nttdocomo.dpoint.start://"
    linkTapped(to: appURLScheme, appID: appID)
}

// Instagram
public func instagram()  {
    let appID = "389801252"
    let hokuyuLucky = "hokuyu_lucky"
    let appURLScheme = "Instagram://user?username=\(hokuyuLucky)"
    linkTapped(to: appURLScheme, appID: appID)
}
public func instagramSelectionHeadoffice()  {
    let appID = "389801252"
    let selection_headoffice = "selection_headoffice"
    let appURLScheme = "Instagram://user?username=\(selection_headoffice)"
    linkTapped(to: appURLScheme, appID: appID)
}

// wolt-app
func wolt() {
    let appID = "943905271"
    let appURLScheme = "wolt-app"
    linkTapped(to: appURLScheme, appID: appID)
}

