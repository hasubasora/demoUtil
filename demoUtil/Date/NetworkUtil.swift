
import Foundation
import SystemConfiguration
import UIKit

/// ネットワーク状態を管理するクラス
final class NetworkManager{
    /// ネットワークマネージャのシングルトンインスタンス
    internal static let shared = NetworkManager()
    /// ネットワーク到達可能性をチェックするためのネットワークリーチャビリティ
    private var networkReachability: SCNetworkReachability?
    /// ネットワークチェックを行うためのタイマー
    private var timer: Timer?

    /// イニシャライザ
    private init() {
        var zeroAddress = sockaddr()
        zeroAddress.sa_len = UInt8(MemoryLayout<sockaddr>.size)
        zeroAddress.sa_family = sa_family_t(AF_INET)
        self.networkReachability = SCNetworkReachabilityCreateWithAddress(nil, &zeroAddress)
    }

    ///ネットワークのモニタリングを開始します
    public func startMonitoring() {
        var context = SCNetworkReachabilityContext(version: 0, info: nil, retain: nil, release: nil, copyDescription: nil)
        context.info = UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque())
        if let reachability = networkReachability {
            SCNetworkReachabilitySetCallback(reachability, { (reachability, flags, info) in
                guard let info = info else { return }
                let manager = Unmanaged<NetworkManager>.fromOpaque(info).takeUnretainedValue()
                manager.checkNetworkStatus()
            }, &context)
            SCNetworkReachabilityScheduleWithRunLoop(reachability, CFRunLoopGetCurrent(), CFRunLoopMode.defaultMode.rawValue)
            
            // タイマーを追加して、5秒ごとにネットワーク状態をチェックします
            timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(checkNetworkStatus), userInfo: nil, repeats: true)
        }
    }
    
    ///ネットワークの状態をチェックします
    @objc public func checkNetworkStatus() {
        guard let reachability = networkReachability else { return }
        var flags: SCNetworkReachabilityFlags = []
        SCNetworkReachabilityGetFlags(reachability, &flags)
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        if isReachable && !needsConnection {
            _ = operateStoredData(action: "save", storedValues: NetworkState.OK, forKey: KeyStorage.networkStatusChanged)
            setNotificationCenter()
            stopTimer()
        } else {
            _ = operateStoredData(action: "save", storedValues: NetworkState.NO, forKey: KeyStorage.networkStatusChanged)
            setNotificationCenter()
            startTimer()
        }
    }
    
    /// タイマーを停止します
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    /// タイマーを開始します
    private func startTimer() {
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(checkNetworkStatus), userInfo: nil, repeats: true)
        }
    }
    
    //ネットワークの状態はメソットに通知する
    private func setNotificationCenter() {
        NotificationCenter.default.post(name: NSNotification.Name("NetworkCheckPointCardImageSwitch"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name("NetworkCheckGetShopList"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name("NetworkCheckSendfirstRequest"), object: nil)
        
        /**
         在需要的地方添加
         NotificationCenter.default.addObserver(self, selector: #selector(方法), name: NSNotification.Name("通知名字"), object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(getNewShopList), name: NSNotification.Name("NetworkCheckGetShopList"), object: nil)
         */
    }
}



/**
 需要在AppDelegate里面使用
 import SystemConfiguration
 
 // ネットワークをチェックする
 NetworkManager.shared.startMonitoring()

 checkNetworkConnection()
 // 外部URL初期化
 URLConfig.initUrl()
 // 設定初期化
 DeviceScene.initConfig()

 
 func checkNetworkConnection() {
     if isInternetAvailable() {
         _ = operateStoredData(action: "save", storedValues: NetworkState.OK, forKey: KeyStorage.networkStatusChanged)
     } else {
         _ = operateStoredData(action: "save", storedValues: NetworkState.NO, forKey: KeyStorage.networkStatusChanged)
     }
 }

 func isInternetAvailable() -> Bool {
     var zeroAddress = sockaddr_in()
     zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
     zeroAddress.sin_family = sa_family_t(AF_INET)
     
     guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
         $0.withMemoryRebound(to: sockaddr.self, capacity: 1) { zeroSockAddress in
             SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
         }
     }) else {
         return false
     }
     
     var flags: SCNetworkReachabilityFlags = []
     if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
         return false
     }
     
     let isReachable = flags.contains(.reachable)
     let needsConnection = flags.contains(.connectionRequired)
     return (isReachable && !needsConnection)
 }

 func updateApplicationIconBadgeNumber() {
     let application = UIApplication.shared
     let currentBadgeNumber = application.applicationIconBadgeNumber
     application.applicationIconBadgeNumber = currentBadgeNumber + 1
 }

 
 
 
 
 */
