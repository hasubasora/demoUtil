//
//  AESCryptorUtil.swift
//  demoUtil
//
//  Created by 羽柴空 on 2024/07/31.
//

import Foundation
import CryptoSwift

// AES CBC 暗号化
func aesEncryptCBC(plainText: String, key: String, iv: String) throws -> String {
    let keyBytes = Array(key.utf8)
    let ivBytes = Array(iv.utf8)
    let dataBytes = Array(plainText.utf8)
    
    let aes = try AES(key: keyBytes, blockMode: CBC(iv: ivBytes), padding: .pkcs7) // PKCS7パディング
    let encryptedBytes = try aes.encrypt(dataBytes)
    return Data(encryptedBytes).base64EncodedString()
}

// AES CBC 復号化
func aesDecryptCBC(encryptedText: String, key: String, iv: String) throws -> String {
    let keyBytes = Array(key.utf8)
    let ivBytes = Array(iv.utf8)
    
    guard let encryptedData = Data(base64Encoded: encryptedText) else {
        throw NSError(domain: "無効なbase64文字列", code: -1, userInfo: nil)
    }
    let encryptedBytes = [UInt8](encryptedData)
    
    let aes = try AES(key: keyBytes, blockMode: CBC(iv: ivBytes), padding: .pkcs7)
    let decryptedBytes = try aes.decrypt(encryptedBytes)
    return String(data: Data(decryptedBytes), encoding: .utf8) ?? ""
}

// URLエンコード
func urlEncode(_ string: String) -> String {
    return string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? string
}

// MARK: - 使用方法
func initView() {
    // サンプルデータ
    let rakutacard = "rakutacard=889988998899"
    let digitaldata = "digitaldata=666888"
    let combinedString = "\(rakutacard),\(digitaldata)"

    // 鍵とIV
    let key = "12345678901234567890123456789012" // 32バイトの鍵
    let iv = "abcdefghijklmnop" // 16バイトのIV

    do {
        // 暗号化
        let encryptedString = try aesEncryptCBC(plainText: combinedString, key: key, iv: iv)
        print("暗号化された文字列: \(encryptedString)")
        
        // URLエンコード
        let urlEncodedString = urlEncode(encryptedString)
        var components = URLComponents()
        components.scheme = "https"
        components.host = "www.example.com"
        components.path = "/secure-data"
        components.queryItems = [URLQueryItem(name: "data", value: urlEncodedString)]
        if let url = components.url {
            print("暗号化してURLエンコードされたURL: \(url)")
        }
        
        // 復号化
        let decryptedString = try aesDecryptCBC(encryptedText: encryptedString, key: key, iv: iv)
        print("復号化された文字列: \(decryptedString)")
    } catch {
        print("暗号化または復号化に失敗しました: \(error)")
    }
}
