////
////  AESCryptor.swift
////  demoUtil
////
////  Created by 羽柴空 on 2024/07/29.
////
//import Foundation
//import CryptoSwift
//
//func generateRandomString(length: Int) -> String {
//    let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
//    let charactersCount = characters.count
//    var randomString = ""
//    
//    for _ in 0..<length {
//        let randomIndex = Int(arc4random_uniform(UInt32(charactersCount)))
//        let character = characters[characters.index(characters.startIndex, offsetBy: randomIndex)]
//        randomString.append(character)
//    }
//    
//    return randomString
//}
//
//struct EncryptionConstants {
//    // 共通鍵
//    static let ENCRYPT_KEY = generateRandomString(length: 30)
//    // 初期化ベクトル
//    static let INIT_VECTOR = "2021ba5f7816fc2d"
//}
//// AES暗号化と復号化を行うクラス
//final class AESCryptor {
//    // アルゴリズム/ブロックモード/パディング方式
//    private let ALGORITHM = "AES/CBC/PKCS5Padding"
//    
//    private let keyData: Data
//    private let ivData: Data
//    
//    /// イニシャライザ
//    init() {
//        keyData = EncryptionConstants.ENCRYPT_KEY.data(using: .utf8)!
//        ivData = EncryptionConstants.INIT_VECTOR.data(using: .utf8)!
//    }
//    
//    /// メッセージをAES CBC PKCS5Padding方式で暗号化する
//    /// - Parameter message: 暗号化するメッセージ
//    /// - Throws: 暗号化に失敗した場合
//    /// - Returns: 暗号化されたメッセージのBase64エンコード文字列
//    func encrypt(message: String) throws -> String {
//        guard let data = message.data(using: .utf8) else {
//            throw CryptoError.dataConversionFailure
//        }
//        
//        let aes = try AES(key: keyData.bytes, blockMode: CBC(iv: ivData.bytes), padding: .pkcs7)
//        let encryptedBytes = try aes.encrypt(data.bytes)
//        let encryptedData = Data(encryptedBytes)
//        
//        return encryptedData.base64EncodedString()
//    }
//
//    /// AES CBC PKCS5Padding方式で暗号化されたメッセージを復号化する
//    /// - Parameter base64Encoded: 暗号化されたメッセージのBase64エンコード文字列
//    /// - Throws: 復号化に失敗した場合
//    /// - Returns: 復号化されたメッセージ
//    func decrypt(base64Encoded: String) throws -> String {
//        guard let data = Data(base64Encoded: base64Encoded) else {
//            throw CryptoError.dataConversionFailure
//        }
//        
//        let aes = try AES(key: keyData.bytes, blockMode: CBC(iv: ivData.bytes), padding: .pkcs7)
//        let decryptedBytes = try aes.decrypt(data.bytes)
//        let decryptedData = Data(decryptedBytes)
//        
//        guard let decryptedString = String(data: decryptedData, encoding: .utf8) else {
//            throw CryptoError.dataConversionFailure
//        }
//        
//        return decryptedString
//    }
//    
//    /// 暗号化や復号化のエラーを示す列挙型
//    enum CryptoError: Error {
//        case dataConversionFailure
//    }
//}
//
//// AESCryptor クラスの使用例
////do {
////    let aesCryptor = AESCryptor()
////    //ターゲット文字列(デフォルト値)
////    plaintext = "shop_cd=\(storeCode!),name_kana=\(nameKana!),tel_no=\(phoneNumber!),maker_id=\(manufacturer!),model_id=\(carModel!),etc=\(etc!),pid=\(identify.getCurrentUser().pid),send_time=\(getCurrentFormattedDate())"
////    // メッセージを暗号化
////    encryptedMessage = try aesCryptor.encrypt(message: plaintext)
////    guard let encodedMessage = encryptedMessage.urlEncoded() else {
////        return
////    }
