//
//  CustomFormJP.swift
//  demoUtil
//
//  Created by 羽柴空 on 2024/07/31.
//

import Foundation
// MARK: - 自定义检测 输入文本到方法 返回 true false

/// 入力された文字列が有効な日本語文字セットのみを含むかどうかをチェックする関数
///
/// - Parameter text: チェックする文字列
/// - Returns: 文字列が有効な文字のみを含む場合は true、それ以外の場合は false を返す
private  func isValidJapaneseCharacterSet(_ text: String) -> Bool {
    // 許可されている文字セットを定義（半角片仮名、平仮名、全角片仮名を含む）
    let allowedCharacters = CharacterSet(charactersIn: "ｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾏﾐﾑﾒﾓﾔﾕﾖﾜｦﾝｶﾞｷﾞｸﾞｹﾞｺﾞｻﾞｼﾞｽﾞｾﾞｿﾞﾀﾞﾁﾞﾂﾞﾃﾞﾄﾞﾊﾞﾋﾞﾌﾞﾍﾞﾎﾞﾊﾟﾋﾟﾌﾟﾍﾟﾎﾟｳﾞｧｨｩｪｫｯｬｭｮあいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほまみむめもやゐゆゑよわをんがぎぐげござじずぜぞだぢづでどばびぶべぼぱぴぷぺぽゔぁぃぅぇぉっゃゅょゎアイウエオカキクケコサシスセソタチツテトナニヌネノハヒフヘホマミムメモヤヰユヱヨワヲンガギグゲゴザジズゼゾダヂヅデドバビブベボパピプペポヴァィゥェォッャュョヮ")
    
    // 入力された文字列を文字セットに変換
    let characterSet = CharacterSet(charactersIn: text)
    
    // 入力された文字セットが許可された文字セットの部分集合であるかどうかをチェック
    return allowedCharacters.isSuperset(of: characterSet)
}
/// 半角片仮名と平仮名を全角片仮名に変換するメソッド
///
/// - Parameter input: 変換するテキスト
/// - Returns: 変換された全角片仮名のテキスト
private func convertToFullWidthKatakana(input: String) -> String {
    // 全角片仮名文字セット
    let fullWidthKatakana = "アイウエオカキクケコサシスセソタチツテトナニヌネノハヒフヘホマミムメモヤユヨワヲンガギグゲゴザジズゼゾダヂヅデドバビブベボパピプペポヴァィゥェォッャュョヮ"
    
    // 半角片仮名文字セット
    let halfWidthKatakana = "ｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾏﾐﾑﾒﾓﾔﾕﾖﾜｦﾝｶﾞｷﾞｸﾞｹﾞｺﾞｻﾞｼﾞｽﾞｾﾞｿﾞﾀﾞﾁﾞﾂﾞﾃﾞﾄﾞﾊﾞﾋﾞﾌﾞﾍﾞﾎﾞﾊﾟﾋﾟﾌﾟﾍﾟﾎﾟｳﾞｧｨｩｪｫｯｬｭｮ"
    
    // 平仮名文字セット
    let hiragana = "あいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほまみむめもやゆよわをんがぎぐげござじずぜぞだぢづでどばびぶべぼぱぴぷぺぽゔぁぃぅぇぉっゃゅょゎ"
    
    // 変換マップを構築
    var conversionMap = [Character: Character]()
    
    // 半角片仮名から全角片仮名への変換マップを構築
    for (index, char) in halfWidthKatakana.enumerated() {
        conversionMap[char] = fullWidthKatakana[fullWidthKatakana.index(fullWidthKatakana.startIndex, offsetBy: index)]
    }
    
    // 平仮名から全角片仮名への変換マップを構築
    for (index, char) in hiragana.enumerated() {
        conversionMap[char] = fullWidthKatakana[fullWidthKatakana.index(fullWidthKatakana.startIndex, offsetBy: index)]
    }
    
    // 文字列を変換
    let convertedString = input.map { conversionMap[$0] ?? $0 }
    
    return String(convertedString)
}

// MARK: - 正则检测名字是不是日文和全角半角转换

/// 名前が有効かどうかを検証するメソッド 日文包括全角半角特殊字符平假名片假名
///
/// - Parameter name: 検証する名前
/// - Returns: 有効な場合は `true`、それ以外の場合は `false`
private func validateName(_ name: String) -> Bool {
    /// 片仮名のみを許可する正規表現
    let kanaRegex = "^[\\u3040-\\u309F\\u30A0-\\u30FF｡-｣ｦ-ﾝﾞﾟ]*$"
    let nameTest = NSPredicate(format: "SELF MATCHES %@", kanaRegex)
    
    /// 正規表現に一致し、文字数が1から30の範囲内であるかを検証
    return nameTest.evaluate(with: name) && name.count >= 1 && name.count <= 30
}
/// 半角片仮名を全角片仮名に変換するメソッド
///
/// - Parameter text: 変換するテキスト
/// - Returns: 変換された全角片仮名のテキスト
private func convertToFullWidthKatakana(_ text: String) -> String {
    // 半角片仮名を全角片仮名に変換して返す
    return text.applyingTransform(.fullwidthToHalfwidth, reverse: true) ?? text
}

/// 平仮名を片仮名に変換するメソッド
///
/// - Parameter text: 変換するテキスト
/// - Returns: 変換された片仮名のテキスト
private func convertHiraganaToKatakana(_ text: String) -> String {
    let mutableString = NSMutableString(string: text) as CFMutableString
    CFStringTransform(mutableString, nil, kCFStringTransformHiraganaKatakana, false)
    return mutableString as String
}
