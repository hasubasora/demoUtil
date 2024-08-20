////
////  InitialNetworkConnection.swift
////  CoreApp
////
////  Created by CHEN YONGHAN on 2024/06/18.
////
//
//import Foundation
//import SystemConfiguration
//import UIKit
//
///// ネットワーク接続状態をチェックし、ストレージに保存します。
/////
///// インターネット接続の有無を確認し、その結果を `operateStoredData` メソッドを使用してストレージに保存します。
///// ネットワーク接続が利用可能な場合は `NetworkState.OK` を、そうでない場合は `NetworkState.NO` を保存します。
//func checkNetworkConnection() {
//    if isInternetAvailable() {
//        _ = operateStoredData(action: "save", storedValues: NetworkState.OK, forKey: KeyStorage.networkStatusChanged)
//    } else {
//        _ = operateStoredData(action: "save", storedValues: NetworkState.NO, forKey: KeyStorage.networkStatusChanged)
//    }
//}
//
///// インターネット接続が利用可能かどうかを確認します。
/////
///// インターネット接続が利用可能で、接続が必要ない状態である場合に `true` を返します。
///// それ以外の場合は `false` を返します。
///// - Returns: インターネット接続が利用可能で、接続が必要ない場合は `true`。それ以外は `false`。
//func isInternetAvailable() -> Bool {
//    var zeroAddress = sockaddr_in()
//    zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
//    zeroAddress.sin_family = sa_family_t(AF_INET)
//    
//    guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
//        $0.withMemoryRebound(to: sockaddr.self, capacity: 1) { zeroSockAddress in
//            SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
//        }
//    }) else {
//        return false
//    }
//    
//    var flags: SCNetworkReachabilityFlags = []
//    if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
//        return false
//    }
//    
//    let isReachable = flags.contains(.reachable)
//    let needsConnection = flags.contains(.connectionRequired)
//    return (isReachable && !needsConnection)
//}
//
///// アプリケーションアイコンのバッジ番号を更新します。
/////
///// 現在のバッジ番号を取得し、1 を加算してアイコンのバッジ番号を更新します。
//func updateApplicationIconBadgeNumber() {
//    let application = UIApplication.shared
//    let currentBadgeNumber = application.applicationIconBadgeNumber
//    application.applicationIconBadgeNumber = currentBadgeNumber + 1
//}
