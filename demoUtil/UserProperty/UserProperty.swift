//
//  UserProperty.swift
//  demoUtil
//
//  Created by 羽柴空 on 2024/07/22.
//

import Foundation

#if canImport(NautilusAnalyticsSDK)
private func setUserProperty(){
///ユーザープロパティ設定
let user = NautilusIdentify.identify().getCurrentUser()
analytics.setUserID(user.pid)
analytics.sendUserProperty()
}
#endif



#if canImport(NautilusAnalyticsSDK)

    private func setEventPropertyAndUserProperty(){
        let formattedDateString = newDateStringInJapan()
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                self.analytics.setUserProperty("Push許諾",value:"可")
            } else {
                self.analytics.setUserProperty("Push許諾",value:"不可")
            }
        }
        
        // 時間が存在するかどうかを確認
        if let isDate = operateStoredData(action: "get", forKey: KeyStorage.lastLaunchDate) as? String {
            // 存在する場合は現在の時間と比較する
            if formattedDateString != isDate {
                // 現在の時間と異なる場合は再保存
                _ = operateStoredData(action: "save", storedValues: formattedDateString, forKey: KeyStorage.lastLaunchDate)
                analytics.setUserProperty("最終起動日",value:formattedDateString)
                return
            }
        }else{
            // 存在しない場合は時間を保存
            _ = operateStoredData(action: "save", storedValues: formattedDateString, forKey: KeyStorage.lastLaunchDate)
            analytics.setUserProperty("最終起動日",value:formattedDateString)
        }
        analytics.setUserProperty("登録者両数",value:getSelectedCarInfoCount())

        if let prefecture = operateStoredData(action: "get", forKey: "prefecture") as? String{
            analytics.setUserProperty("都道府県名", value: prefecture)
        }
        if let isBirthDate = operateStoredData(action: "get", forKey: "birthDate") as? String{
            analytics.setUserProperty("誕生年月日", value: isBirthDate)
        }
        //登録車両（メーカー）,登録車両（車種）, 登録者両数
        if selectedCarInfo.count != 0 {
            let makerNames = selectedCarInfo.compactMap { $0["maker_name"] }.joined(separator: "/")
            let modelNames = selectedCarInfo.map { info -> String in
                if let sortId = info["sort_id"], sortId == "999" {
                    return info["etc"] ?? ""
                } else {
                    return info["model_name"] ?? ""
                }
            }.joined(separator: "/")

            let finalModelNames = modelNames
            let finalMakerNames = makerNames

            analytics.setUserProperty("登録車両（メーカー）", value: finalMakerNames)
            analytics.setUserProperty("登録車両（車種）", value: finalModelNames)
        }

        analytics.sendUserProperty()

    }
#endif
