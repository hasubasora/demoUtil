//
//  WebViewSignin.swift
//  CoreApp
//
//  Created by CHEN YONGHAN on 2024/1/3.
//

import UIKit
import WebKit

/// WebViewSigninは、ウェブビューのサインイン画面を表すビューコントローラーです。WKNavigationDelegateを採用しています。
final class WebViewSignin: UIViewController, WKNavigationDelegate, NavigationBarActions {
    
    private var webView: WKWebView!
    /// Web ページのタイトル
    public var webTitle = ""
    /// 表示する URL
    public var url: URL?
    
    public var onClose: (() -> Void)?
    
    /// ナビゲーションバーのスタイルを指定するプロパティ
    public var useBackButton: Bool = false

    /// ビューが読み込まれたときに呼ばれるメソッド
    internal override func viewDidLoad() {
        super.viewDidLoad()
        
        // ナビゲーションバーをセットアップします
        setupNavigationBar()
        
        // ネットワーク状態を確認し、接続がない場合はアラートを表示します
        if let networkStatusString = operateStoredData(action: "get", forKey: KeyStorage.networkStatusChanged) as? String,
           let networkStatus = NetworkState(rawValue: networkStatusString) {
/**
NetworkState(rawValue: networkStatusString)：
NetworkState 是一个枚举，通过它的 rawValue 初始化，试图将存储的字符串 networkStatusString 转换为对应的 NetworkState 枚举。
networkStatus：如果 networkStatusString 匹配了枚举的 rawValue，它会被转换为对应的枚举值（如 .reachable 或 .unreachable）。
            如果 networkStatusString 不匹配任何 rawValue，则 networkStatus 为 nil。
 */
            // ネットワーク状態が "unreachable" の場合、アラートを表示
            if networkStatus == .unreachable {
                showAlert(title: "", message: NetworkErrorMessages.networkConnectionError, actionTitle: "OK") {
                    // アラート表示後の処理がここに入る（必要であれば）
                }
                return
            }
        }


        
        // WKWebView の設定を行います
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.navigationDelegate = self
        view.addSubview(webView)
        
        // セーフエリアに合わせて webView の制約を設定します
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        // iOS 11.0 以降の対応
        if #available(iOS 11.0, *) {
            webView.scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        // iOS 15.0 以降の UINavigationBar の外観対応
        if #available(iOS 15.0, *) {
            let navigationBarAppearance = UINavigationBarAppearance()
            navigationBarAppearance.configureWithDefaultBackground()
            navigationBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.black]
            UINavigationBar.appearance().standardAppearance = navigationBarAppearance
            UINavigationBar.appearance().compactAppearance = navigationBarAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        }
        
        //URL が設定されている場合はリクエストをロードします
        if let url = url {
            let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0)
            webView.load(request)
        }
    }
    
    internal func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url,
           url.scheme == "tel" {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                decisionHandler(.cancel)
                return
            }
        }
        decisionHandler(.allow)
    }
    
    /// ナビゲーションバーの設定を行います
    private func setupNavigationBar() {
        if useBackButton {
            NavigationBarConfigurator.setupNavigationBar(for: self, style: .withBackButton(center: .text(webTitle), right: nil))
        } else {
            NavigationBarConfigurator.setupNavigationBar(for: self, style: .basic(center: .text(webTitle)))
        }
    }
    
    /// ビューが表示される直前に呼ばれるメソッド
    internal override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // ナビゲーションバーを再設定します
        setupNavigationBar()
        
        // 旧の webView が存在する場合、まずそれを削除します
        webView?.removeFromSuperview()
        webView = nil
        
        // 新しい WKWebView を作成し、設定します
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.navigationDelegate = self
        view.addSubview(webView)
        
        // 制約を再適用します
        setupWebViewConstraints()
        
        // 初期 URL をロードします
        if let url = url {
            var request = URLRequest(url: url)
            // キャッシュされたデータを使用します。キャッシュがない場合はネットワークからロードします。
            request.cachePolicy = .returnCacheDataElseLoad
            webView.load(request)
        }
    }
    
    /// webViewの制約を適用する
    private func setupWebViewConstraints() {
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    /// 戻るボタンがタップされたときの処理
    @objc internal func LeftButtonTapped() {
        self.onClose?()
        dismiss(animated: true, completion: nil)
    }
}
