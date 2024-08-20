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
    
//    validator.containsOnlyKatakana(text)
//    只检查片假名
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
    
    // メソッド：メールアドレスの形式を検証します（正規表現版）
    //
    // - Parameter email: チェックするメールアドレス
    // - Returns: メールアドレスの形式が有効であれば true、それ以外の場合は false
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegEx).evaluate(with: email)
    }
    
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
//
    // メソッド：指定された入力が特定の正規表現ルールに一致するかを確認します。
    //
    // - Parameter input: 検証する文字列
    // - Returns: 入力が正規表現ルールに一致する場合は true、それ以外の場合は false
    func isValidInput(_ input: String) -> Bool {
        let regex = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        return predicate.evaluate(with: input)
    }
}

// UnicodeScalarの拡張
extension UnicodeScalar {
    var isFullWidth: Bool {
        return (0xFF00...0xFFEF).contains(value) || (0x3000...0x303F).contains(value)
    }
}
