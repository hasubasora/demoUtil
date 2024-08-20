////
////  CodeManagerUtil.swift
////  demoUtil
////
////  Created by 羽柴空 on 2024/07/12.
////
//import Foundation
////import NautilusIdentifySDK
////import NautilusNotificationSDK
//
///// 顧客管理コードを連携する
/////
///// - Parameters:
/////   - manageCode: 顧客管理コードに入れる
//
////https://ext-team.lvdev.jp/redmine/projects/ma20_dev/wiki/%E3%83%9E%E3%83%8D%E3%83%BC%E3%82%B8%E3%82%B3%E3%83%BC%E3%83%89%E7%AE%A1%E7%90%86_%E3%82%A2%E3%83%97%E3%83%AA%E5%81%B4%E3%81%A7%E3%81%AE%E5%AF%BE%E5%BF%9C%E5%86%85%E5%AE%B9%E3%81%AB%E3%81%A4%E3%81%84%E3%81%A6#%E3%83%97%E3%83%83%E3%82%B7%E3%83%A5%E3%81%AE%E9%85%8D%E4%BF%A1%E5%AF%BE%E8%B1%A1%E3%82%92%E3%83%9E%E3%83%8D%E3%83%BC%E3%82%B8%E3%82%B3%E3%83%BC%E3%83%89%E3%81%AE%E7%99%BB%E9%8C%B2%E3%81%AB%E5%A4%89%E6%9B%B4%E3%81%99%E3%82%8B-2
//// TODO: 対象の顧客管理コードの紐付けが成功しているかを確認する
//// TODO: すでにサーバーでの紐付け処理に成功していれば、以降の処理はしない
//
//// コンテンツ配信対象として、顧客管理コードを連携する
//public func manageCodeChange(digitalManageCode:String){
//    let identify = NautilusIdentify.identify()
//    let userPid = identify.getCurrentUser().pid
//    let userCid = identify.cid
//    
//    NautilusIdentify.identify().setManageCode(userID: userPid,
//                                              manageCode:digitalManageCode,
//                                              completion: {
//        switch $0 {
//        case .success:
//            // 顧客管理コードの紐付け成功
//            print("顧客管理コードの紐付け成功")
//            // TODO: アプリ内での「コンテンツ配信対象として、顧客管理コードが連携」出来た状態であることを保存する
//            
//            // 顧客管理コードのサーバーステータスを「ログイン」で登録する
//            serverStatusToLogin(digitalManageCode: digitalManageCode)
//            
//            // 顧客管理コードの紐付けが成功するとPIDが変わる場合があるので
//            // 紐付け後に、プッシュ通知を受け取れるように、改めて
//            // PIDをプッシュの配信対象として登録する
//            NautilusNotification.notification().registerPushTarget(registrationTarget: .init(pid: userPid),
//                                                                   completion: {
//                switch $0 {
//                case .success:
//                    // 現在のPIDをプッシュ対象として登録できた
//                    print("現在のPIDをプッシュ対象として登録できた")
//                    // TODO: アプリ内での「プッシュ配信対象として、顧客管理コードが連携」出来た状態であることを保存する
//                    // TODO: このタイミングで、何か処理をする要件があれば処理を行う
//                    break
//                case .failure(let error):
//                    print("現在のPIDをプッシュ対象として登録できなかった")
//                    print(error)
//                    // 現在のPIDをプッシュ対象として登録できなかった
//                    // TODO: アプリ内での「プッシュ配信対象として、顧客管理コードが連携」出来なかった状態であることを保存する
//                    // TODO: 顧客管理コードを利用してプッシュ通知を受け取れない状態になるため、ハンドリングが必要
//                    break
//                }
//            })
//            
//        case .failure(let error):
//            print("通信はできたが、サーバー側で処理に失敗した")
//            print(error)
//            // ここは「通信はできたが、サーバー側で処理に失敗した」場合 or 「通信自体に失敗した」場合 (`error`の値で確認可能)
//            // 顧客管理コードの紐付け失敗
//            
//            // TODO: アプリ内での「コンテンツ配信対象として、顧客管理コードが連携」出来なかった状態であることを保存する
//            // TODO: アプリ内での紐付けが失敗している状態になるため、クリティカルな場合はハンドリングが必要
//            
//            break
//        }
//        
//    })//NautilusIdentify
//}
//
//func registerCidForPushTargetIfNeeded() {
//    // TODO: CIDをプッシュ配信対象に登録済みの場合、returnする
//    NautilusNotification.notification().registerPushTarget(registrationTarget: .init(cid: userCid)) {
//        switch $0 {
//        case .success:
//            // TODO: CIDをプッシュ配信対象に登録済みにする
//            print(" CIDをプッシュ配信対象に登録済みにする")
//        case .failure(_):break
//        }
//    }
//}
//
////ログイン状態を登録する
//public func serverStatusToLogin(digitalManageCode:String){
//    NautilusIdentify.identify().setServerStatusToLogin(
//        manageCode: digitalManageCode,
//        completion: {
//            switch $0 {
//            case .success:
//                // ログイン状態の登録に成功
//                print("ログイン状態の登録に成功")
//                break
//            case .failure(let error):
//                // ログイン状態の登録に失敗
//                print("ログイン状態の登録に失敗\(error)")
//                // リトライ処理を行うこと
//                break
//            }
//        }
//    )
//}
//
////ログアウト状態を登録する
//public func serverStatusToLogout(){
//    NautilusIdentify.identify().setServerStatusToLogout(
//        completion: {
//            switch $0 {
//            case .success:
//                // ログアウト状態の登録に成功
//                print("ログアウト状態の登録に成功")
//                break
//            case .failure(let error):
//                print("ログアウト状態の登録に失敗\(error)")
//                // ログアウト状態の登録に失敗
//                // リトライ処理を行うこと
//                break
//            }
//        }
//    )
//}
