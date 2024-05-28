//
//  DateComponentsUtil.swift
//  CoreApp
//
//  Created by 羽柴空 on 2024/05/20.
//

import Foundation

// 現在の年を取得
func getCurrentYear() -> Int {
    let currentDate = Date()
    let calendar = Calendar.current
    let currentYear = calendar.component(.year, from: currentDate)
    return currentYear
}

// 過去100年の配列を取得
func getYearsArray() -> [String] {
    let currentYear = getCurrentYear()
    var yearsArray: [String] = []
    for year in (currentYear - 100)...currentYear {
        yearsArray.append(String(year))
    }
    return yearsArray
}

// 現在の年から25年前の年を取得
func getYear25YearsAgo() -> String {
    let currentYear = getCurrentYear()
    return String(currentYear - 25)
}

// 特定の年のインデックスを取得
func getIndexOfYear(_ year: String, in yearsArray: [String]) -> Int? {
    return yearsArray.firstIndex(of: year)
}

// 月の配列を取得
func getMonthsArray(for year: String) -> [String] {
    let currentYear = Calendar.current.component(.year, from: Date())
    let currentMonth = Calendar.current.component(.month, from: Date())

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

// 指定された年と月の日の配列を取得
//func getDaysArray(year: Int, month: Int) -> [Int] {
//    let calendar = Calendar.current
//    var days: [Int] = []
//    var dateComponents = DateComponents()
//    dateComponents.year = year
//    dateComponents.month = month
//
//    if let date = calendar.date(from: dateComponents),
//       let range = calendar.range(of: .day, in: .month, for: date) {
//        days = Array(range)
//    }
//    return days
//}

// 指定された年と月の日の配列を取得
func getDaysArray(year: String, month: String) -> [String] {
    guard let yearInt = Int(year), let monthInt = Int(month) else {
        return []
    }

    let calendar = Calendar.current
    var days: [String] = []
    var dateComponents = DateComponents()
    dateComponents.year = yearInt
    dateComponents.month = monthInt

    if let date = calendar.date(from: dateComponents),
       let range = calendar.range(of: .day, in: .month, for: date) {
        let currentDate = Date()
        let currentYear = calendar.component(.year, from: currentDate)
        let currentMonth = calendar.component(.month, from: currentDate)
        let currentDay = calendar.component(.day, from: currentDate)

        for day in range {
            dateComponents.day = day
            if let _ = calendar.date(from: dateComponents),
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

