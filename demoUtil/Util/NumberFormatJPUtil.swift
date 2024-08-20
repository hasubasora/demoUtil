//
//  NumberFormatJPUtil.swift
//  demoUtil
//
//  Created by 羽柴空 on 2024/07/12.
//

import Foundation
/// 数字をフォーマットする
///
/// - Parameter number: フォーマットする数字
/// - Returns: フォーマットされた文字列
public func numberFormatToJaJp(_ number: Double) -> String {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    numberFormatter.locale = Locale(identifier: "ja_JP")
    if let formattedString = numberFormatter.string(from: NSNumber(value: number)) {
        return formattedString
    } else {
        return ""
    }
}
//let number = 12345.678
//let formattedString = NumberFormatUtil.numberFormatToJaJp(number)
//print(formattedString)  // 输出: 12,345.678

