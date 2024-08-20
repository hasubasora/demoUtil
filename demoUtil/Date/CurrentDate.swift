//
//  CurrentDate.swift
//  demoUtil
//
//  Created by 羽柴空 on 2024/08/09.
//

import Foundation
import UIKit

/// 現在の日時を "2000/01/01" 形式で取得する関数
///
/// - Returns: "yyyy/MM/dd" 形式の日付文字列
public func getCurrentDateFormatted() -> String {
    let date = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.calendar = Calendar(identifier: .gregorian)
    dateFormatter.dateFormat = "yyyy/MM/dd"
    let formattedDate = dateFormatter.string(from: date)
    return formattedDate
}

/// 現在の日時をフォーマットされた文字列として取得する関数
///
/// - Returns: "yyyyMMdd HH:mm:ss.SSSS" 形式の日付文字列
public func getCurrentFormattedDate() -> String {
    let currentDate = Date()
    let formatter = DateFormatter()
    formatter.calendar = Calendar(identifier: .gregorian)
    formatter.dateFormat = "yyyyMMdd HH:mm:ss.SSSS"
    let formattedDate = formatter.string(from: currentDate)
    return formattedDate
}

/// Date VS Date を比較します。
///
/// - Parameters:
///   - dateString1: 比較する日付文字列1
///   - dateString2: 比較する日付文字列2
/// - Returns: 日付1が日付2より後の場合は true、それ以外の場合は false
public func isDate1LaterThanDate2(dateString1: String, dateString2: String) -> Bool {
    let dateFormatter = DateFormatter()
    dateFormatter.calendar = Calendar(identifier: .gregorian)
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXX"
    if let date1 = dateFormatter.date(from: dateString1),
       let date2 = dateFormatter.date(from: dateString2) {
        let timestamp1 = date1.timeIntervalSince1970
        let timestamp2 = date2.timeIntervalSince1970
        return timestamp1 > timestamp2
    }
    return false
}

/// Date を特定のカスタムISO日付文字列にフォーマットします。
///
/// - Parameter date: フォーマットする日付（オプショナル、デフォルトは現在の日付）
/// - Returns: カスタムISO日付文字列
public func formatDateToCustomISODate(_ date: Date = Date()) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.calendar = Calendar(identifier: .gregorian)
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXX"
    dateFormatter.timeZone = TimeZone.current
    let formattedDate = dateFormatter.string(from: date)
    return formattedDate
}

/// 文字列を日付に変換します。
///
/// - Parameter dateString: 変換する日付文字列
/// - Returns: 変換された日付、変換できない場合は nil
public func convertStringToDate(_ dateString: String) -> Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.calendar = Calendar(identifier: .gregorian)
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    return dateFormatter.date(from: dateString)
}

/// 日付文字列を日本の日付表現に変換します。
///
/// - Returns: 変換された日付文字列、変換できない場合は nil。
public func newDateStringInJapan() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.calendar = Calendar(identifier: .gregorian)
    dateFormatter.dateFormat = "yyyy/MM/dd"
    dateFormatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
    
    let currentDate = Date()
    
    return dateFormatter.string(from: currentDate)
}
