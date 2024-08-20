////
////  NetworkHelper.swift
////  CoreApp
////
////  Created by CHEN YONGHAN on 2024/02/13.
////
//import Foundation
//import SystemConfiguration
//import UIKit
//
///// ネットワーク状態を管理するクラス
//final class NetworkUtil{
//    /// ネットワークマネージャのシングルトンインスタンス
//    internal static let shared = NetworkUtil()
//    /// ネットワーク到達可能性をチェックするためのネットワークリーチャビリティ
//    private var networkReachability: SCNetworkReachability?
//    /// ネットワークチェックを行うためのタイマー
//    private var timer: Timer?
//
//    /// イニシャライザ
//    private init() {
//        var zeroAddress = sockaddr()
//        zeroAddress.sa_len = UInt8(MemoryLayout<sockaddr>.size)
//        zeroAddress.sa_family = sa_family_t(AF_INET)
//        self.networkReachability = SCNetworkReachabilityCreateWithAddress(nil, &zeroAddress)
//    }
//
//    ///ネットワークのモニタリングを開始します
//    public func startMonitoring() {
//        var context = SCNetworkReachabilityContext(version: 0, info: nil, retain: nil, release: nil, copyDescription: nil)
//        context.info = UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque())
//        if let reachability = networkReachability {
//            SCNetworkReachabilitySetCallback(reachability, { (reachability, flags, info) in
//                guard let info = info else { return }
//                let manager = Unmanaged<NetworkUtil>.fromOpaque(info).takeUnretainedValue()
//                manager.checkNetworkStatus()
//            }, &context)
//            SCNetworkReachabilityScheduleWithRunLoop(reachability, CFRunLoopGetCurrent(), CFRunLoopMode.defaultMode.rawValue)
//            
//            // タイマーを追加して、5秒ごとにネットワーク状態をチェックします
//            timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(checkNetworkStatus), userInfo: nil, repeats: true)
//        }
//    }
//    
//    ///ネットワークの状態をチェックします
//    @objc public func checkNetworkStatus() {
//        guard let reachability = networkReachability else { return }
//        var flags: SCNetworkReachabilityFlags = []
//        SCNetworkReachabilityGetFlags(reachability, &flags)
//        let isReachable = flags.contains(.reachable)
//        let needsConnection = flags.contains(.connectionRequired)
//        if isReachable && !needsConnection {
//            _ = operateStoredData(action: "save", storedValues: NetworkState.OK, forKey: KeyStorage.networkStatusChanged)
//            setNotificationCenter()
//            stopTimer()
//        } else {
//            _ = operateStoredData(action: "save", storedValues: NetworkState.NO, forKey: KeyStorage.networkStatusChanged)
//            setNotificationCenter()
//            startTimer()
//        }
//    }
//    
//    /// タイマーを停止します
//    private func stopTimer() {
//        timer?.invalidate()
//        timer = nil
//    }
//    
//    /// タイマーを開始します
//    private func startTimer() {
//        if timer == nil {
//            timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(checkNetworkStatus), userInfo: nil, repeats: true)
//        }
//    }
//    
//    //ネットワークの状態はメソットに通知する
//    private func setNotificationCenter() {
//        NotificationCenter.default.post(name: NSNotification.Name("NetworkCheckPointCardImageSwitch"), object: nil)
//        NotificationCenter.default.post(name: NSNotification.Name("NetworkCheckGetShopList"), object: nil)
//        NotificationCenter.default.post(name: NSNotification.Name("NetworkCheckSendfirstRequest"), object: nil)
//    }
//}
//
///**
// 在AppDelegate.swift
// 初始化
// NetworkUtil.shared.startMonitoring()
// 
// 需要配合另一个网络检测
// InitialNetworkConnection.swift
//
// checkNetworkConnection()
// */
//
//
//
//
//
////需要的地方建立监听方法
////NotificationCenter.default.addObserver(self, selector: #selector(页面上的方法名字), name: NSNotification.Name("NetworkCheckPointCardImageSwitch"), object: nil)
