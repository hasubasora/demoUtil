//
//  ValidationHelper.swift
//  CoreApp
//
//  Created by 羽柴空 on 2024/05/24.
//

import Foundation

// ValidationHelper.swift
class ValidationHelper {
    
    //validator.isValidLength(userIdTextField.text, minLength: 8, maxLength: 20)
    //最短多少，最长多少，检测文字输入的长度
    // メソッド：文字列の長さが有効かどうかを検証
    //
    // - Parameters:
    //   - text: 検証する文字列
    //   - minLength: 最小長さ
    //   - maxLength: 最大長さ
    // - Returns: 文字列の長さが最小長さ以上かつ最大長さ以下であれば true、それ以外の場合は false
    func isValidLength(_ text: String?, minLength: Int, maxLength: Int) -> Bool {
        guard let text = text else { return false }
        return text.count >= minLength && text.count <= maxLength
    }
    
    // メソッド：非数字の文字を削除して数字のみを返す
    // - Parameters:
    //   - text: 処理する文字列
    // - Returns: テキストから数字以外の文字を削除した新しい文字列
    // 正規表現を使用して、テキストから数字以外のすべての文字を削除し、数字のみを含む文字列を返すメソッド
    func removeNonNumericCharacters(_ text: String) -> String {
        return text.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
    }

    
    //    validator.isValidUserIdOrPassword(text)
    // メソッド：ユーザーIDとパスワードが有効かどうかをチェック
    //
    // - Parameter text: チェックするユーザーIDまたはパスワード
    // - Returns: ユーザーIDまたはパスワードが有効な場合は true、それ以外の場合は false
    func isValidUserIdOrPassword(_ text: String?) -> Bool {
        guard let text = text else { return false }
        let regex = "^[a-zA-Z0-9]*$" // 文字種のみをチェック
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: text)
    }
    
    //    validator.containsHiraganaAndKanji(text)
    
    // メソッド：文字列に漢字とひらがなが含まれているかをチェック
    //
    // - Parameter text: チェックする文字列
    // - Returns: 文字列に漢字とひらがなが含まれていれば true、それ以外の場合は false
    func containsHiraganaAndKanji(_ text: String?) -> Bool {
        guard let text = text else { return false }
        let regex = "^[\\p{Hiragana}\\p{Han}]+$"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: text)
    }
    
    //MARK: - 只检查片假名
    //    validator.containsOnlyKatakana(text)
    // メソッド：文字列が片仮名のみを含むかどうかをチェック
    //
    // - Parameter text: チェックする文字列
    // - Returns: 文字列が片仮名のみであれば true、それ以外の場合は false
    func containsOnlyKatakana(_ text: String?) -> Bool {
        guard let text = text else { return false }
        let regex = "^[\\p{Katakana}]+$"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: text)
    }
    
    // メソッド：日付が有効かどうかを検証
    //
    // - Parameters:
    //   - year: 年の文字列
    //   - month: 月の文字列
    //   - day: 日の文字列
    // - Returns: 指定された年、月、日が有効な日付であれば true、それ以外の場合は false
    func isValidDate(year: String?, month: String?, day: String?) -> Bool {
        guard let year = year, let month = month, let day = day,
              let yearInt = Int(year), let monthInt = Int(month), let dayInt = Int(day) else {
            return false
        }
        
        var dateComponents = DateComponents()
        dateComponents.year = yearInt
        dateComponents.month = monthInt
        dateComponents.day = dayInt
        
        return Calendar(identifier: .gregorian).date(from: dateComponents) != nil
    }
    //MARK: - 检查邮件
    // メソッド：メールアドレスの形式を検証します（正規表現版）
    //
    // - Parameter email: チェックするメールアドレス
    // - Returns: メールアドレスの形式が有効であれば true、それ以外の場合は false
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegEx).evaluate(with: email)
    }
    
    //MARK: - 检查纯数字
    // メソッド：数字の入力が有効かどうかを検証
    //
    // - Parameter text: チェックする文字列
    // - Returns: 入力が数字のみであれば true、それ以外の場合は false
    func isValidNumber(_ text: String?) -> Bool {
        guard let text = text else { return false }
        let regex = "^[0-9]+$"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: text)
    }
    
    //    validationHelper.isValidInput(username)
    
    //MARK: -  检查英文数字的结合
    // メソッド：指定された入力が特定の正規表現ルールに一致するかを確認します。
    //
    // - Parameter input: 検証する文字列
    // - Returns: 入力が正規表現ルールに一致する場合は true、それ以外の場合は false
    func isValidInput(_ input: String) -> Bool {
        let regex = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        return predicate.evaluate(with: input)
    }
    
    //MARK: -  日文检测片假名和其他是不是全角
    //// 示例测试
    //print(isFullWidth(input: "ＡＢＣ１２３")) // 输出：true
    //print(isFullWidth(input: "ABC123"))     // 输出：false
    //print(isFullWidth(input: "あ漢。"))      // 输出：false
    //print(isFullWidth(input: "アイウ"))      // 输出：true
    func isFullWidth1(input: String) -> Bool {
        for character in input {
            for scalar in character.unicodeScalars {
                let value = scalar.value
                // 检查字符是否在全角字符的范围内
                if !(value >= 0xFF01 && value <= 0xFF60) && !(value >= 0xFFE0 && value <= 0xFFE6) {
                    return false
                }
            }
        }
        return true
    }
    //MARK: -  日文检测平假名和其他是不是全角
    //// テスト例
    //print(isFullWidth(input: ""))         // 出力：true
    //print(isFullWidth(input: "あ漢。"))    // 出力：true
    //print(isFullWidth(input: "アイウ"))    // 出力：true
    //print(isFullWidth(input: "ABC123"))   // 出力：false
    //print(isFullWidth(input: "ＡＢＣ１２３")) // 出力：true
    func isFullWidth(input: String) -> Bool {
        // 入力が空文字列の場合、trueを返す
        if input.isEmpty {
            return true
        }
        
        for character in input {
            for scalar in character.unicodeScalars {
                let value = scalar.value
                // 文字が全角かどうかをチェックする
                if !(value >= 0xFF01 && value <= 0xFF60) &&  // 全角ASCII範囲
                    !(value >= 0xFFE0 && value <= 0xFFE6) &&  // 全角記号範囲
                    !(value >= 0x3000 && value <= 0x303F) &&  // 日本語記号と句読点
                    !(value >= 0x3040 && value <= 0x309F) &&  // ひらがな
                    !(value >= 0x30A0 && value <= 0x30FF) &&  // カタカナ
                    !(value >= 0x4E00 && value <= 0x9FFF) {   // 漢字
                    return false
                }
            }
        }
        return true
    }
}
//MARK: -  extension

// UnicodeScalarの拡張
extension UnicodeScalar {
    var isFullWidth: Bool {
        return (0xFF00...0xFFEF).contains(value) || (0x3000...0x303F).contains(value)
    }
}
