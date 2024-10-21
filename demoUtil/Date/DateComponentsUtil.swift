//
//  DateComponentsUtil.swift
//  CoreApp
//
//  Created by CHEN YONGHAN on 2024/05/20.
//

import Foundation

/// 現在の年を取得します。
///
/// - Returns: 現在の年
public func getCurrentYear() -> Int {
    let currentDate = Date()
    let gregorianCalendar = Calendar(identifier: .gregorian)
    let currentYear = gregorianCalendar.component(.year, from: currentDate)
    return currentYear
}

/// 過去100年の配列を取得します。
///
/// - Returns: 過去100年の文字列配列
public func getYearsArray() -> [String] {
    let currentYear = getCurrentYear()
    var yearsArray: [String] = []
    for year in (currentYear - 100)...currentYear {
        yearsArray.append(String(year))
    }
    return yearsArray
}

/// 現在の年から25年前の年を取得します。
///
/// - Returns: 現在の年から25年前の年の文字列
public func getYear25YearsAgo() -> String {
    let currentYear = getCurrentYear()
    return String(currentYear - 25)
}

/// 特定の年のインデックスを取得します。
///
/// - Parameters:
///   - year: 特定の年の文字列
///   - yearsArray: 年の配列
/// - Returns: 特定の年のインデックス
public func getIndexOfYear(_ year: String, in yearsArray: [String]) -> Int? {
    return yearsArray.firstIndex(of: year)
}

/// 月の配列を取得します。
///
/// - Parameters:
///   - year: 年の文字列
/// - Returns: 月の文字列配列
public func getMonthsArray(for year: String) -> [String] {
    let gregorianCalendar = Calendar(identifier: .gregorian)
    let currentYear = gregorianCalendar.component(.year, from: Date())
    let currentMonth = gregorianCalendar.component(.month, from: Date())

    guard let yearInt = Int(year) else {
        return []
    }

    if yearInt < currentYear {
        // 過去の年の場合は全ての月を返す
        return (1...12).map { String($0) }
    } else if yearInt == currentYear {
        // 現在の年の場合は現在の月までを返す
        return (1...currentMonth).map { String($0) }
    } else {
        // 未来の年の場合は空の配列を返す
        return []
    }
}

/// 指定された年と月の日の配列を取得します。
///
/// - Parameters:
///   - year: 年の文字列
///   - month: 月の文字列
/// - Returns: 日の文字列配列
public func getDaysArray(year: String, month: String) -> [String] {
    guard let yearInt = Int(year), let monthInt = Int(month) else {
        return []
    }

    let gregorianCalendar = Calendar(identifier: .gregorian)
    var days: [String] = []
    var dateComponents = DateComponents()
    dateComponents.year = yearInt
    dateComponents.month = monthInt

    if let date = gregorianCalendar.date(from: dateComponents),
       let range = gregorianCalendar.range(of: .day, in: .month, for: date) {
        let currentDate = Date()
        let currentYear = gregorianCalendar.component(.year, from: currentDate)
        let currentMonth = gregorianCalendar.component(.month, from: currentDate)
        let currentDay = gregorianCalendar.component(.day, from: currentDate)

        for day in range {
            dateComponents.day = day
            if let _ = gregorianCalendar.date(from: dateComponents),
               yearInt < currentYear || (yearInt == currentYear && monthInt < currentMonth) || (yearInt == currentYear && monthInt == currentMonth && day <= currentDay) {
                days.append(String(day))
            }
        }
    }
    return days
}



/**
 // サンプル呼び出し
 //let yearsArray = getYearsArray()
 //print("過去100年の配列：\(yearsArray)")
 //
 //let monthsArray = getMonthsArray()
 //print("月の配列：\(monthsArray)")
 //
 //let selectedYear = 2024
 //let selectedMonth = 5
 //let daysArray = getDaysArray(year: selectedYear, month: selectedMonth)
 //print("選択した年月の日の配列：\(daysArray)")
 

 */

func getCurrentYearMonth() -> String {
    let calendar = Calendar(identifier: .gregorian)
    let date = Date()
    let components = calendar.dateComponents([.year, .month], from: date)
    
    if let year = components.year, let month = components.month {
        return String(format: "%04d%02d", year, month)
    } else {
        return ""
    }
}
