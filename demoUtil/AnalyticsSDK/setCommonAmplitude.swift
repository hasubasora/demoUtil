//
//  setCommonAmplitude.swift
//  CoreApp
//
//  Created by CHEN YONGHAN on 2024/03/04.
//
#if canImport(NautilusAnalyticsSDK)
import NautilusAnalyticsSDK
#endif

/// アプリで送信するイベントの名前
enum SystemAnalyticsEvent: String {
    /// ホーム画面で予約ボタンをタップする
    case TapReservationButton = "tap reservation button"

    /// 予約情報を登録する
    case RegisterReservationInfo = "register reservation information"

}

/// アプリで送信するイベントのプロパティの名前
enum SystemAnalyticsEventProperty: String {
    case screen_web_view_url = "遷移元"
    case add_memo_key = "入力ワード"
    
}

//extension NautilusAnalytics {
//    /// アプリで定義したイベントを、NautilusAnalyticsに受け渡すメソッド
//    func sendEvent(event: SystemAnalyticsEvent, properties: [String:Any]? = nil) {
//        NautilusAnalytics.analytics().sendEvent(event.rawValue,
//                                                eventProperties: properties)
//    }
//}

/**
 #if canImport(NautilusAnalyticsSDK)
 import NautilusAnalyticsSDK
 #endif
 
 #if canImport(NautilusAnalyticsSDK)
     private var analytics: NautilusAnalytics {
         NautilusAnalytics.analytics()
     }
 #endif
 
 传送携带数据的
analytics.sendEvent(event: .name,properties: data)
 
let shopDataDictionary: [String: Any] = [
    "店舗ID": shopID!,
    "店舗名": shopName.text!
]

#if canImport(NautilusAnalyticsSDK)
// お気に入り店舗のチラシを見る
analytics.sendEvent(event: .TapFavoriteStoreFlyers,properties: shopDataDictionary)
#endif

 单独传送方法
//analytics.sendEvent(event: .TapMemoAdd)
 
 传送自定义方法
 //analytics.sendEvent(event: .ShowMobileCoGCaScreen, properties: [SystemAnalyticsEventProperty.screen_web_view_url.rawValue: "Top画面"])
 */

// このメソッドは特定のビューコントローラを選択する前に呼び出されます
