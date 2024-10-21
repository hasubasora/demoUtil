//
//  ECBCryptor.swift
//  demoUtil
//
//  Created by 羽柴空 on 2024/08/20.
//

import Foundation
import CryptoSwift

func aesEncryptECB(data: String, keyHex: String) throws -> String? {
    // 将十六进制字符串转换为 Data
    guard let keyData = keyHex.hexToData() else {
        throw NSError(domain: "EncryptionError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid key string"])
    }
    
    let dataToEncrypt = Data(data.utf8)
    
    // AES ECB模式不需要初始化向量
    let aes = try AES(key: keyData.bytes, blockMode: ECB(), padding: .pkcs7)
    
    // 加密数据
    let encryptedBytes = try aes.encrypt(dataToEncrypt.bytes)
    
    // 将加密后的数据转换为Base64字符串
    let encryptedData = Data(encryptedBytes)
    let encryptedString = encryptedData.base64EncodedString()
    
    return encryptedString
}

func aesDecryptECB(encryptedBase64: String, keyHex: String) throws -> String? {
    // 将十六进制字符串转换为 Data
    guard let keyData = keyHex.hexToData() else {
        throw NSError(domain: "EncryptionError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid key string"])
    }
    
    // 将 Base64 字符串转换为 Data
    guard let encryptedData = Data(base64Encoded: encryptedBase64) else {
        throw NSError(domain: "DecryptionError", code: 2, userInfo: [NSLocalizedDescriptionKey: "Invalid Base64 string"])
    }
    
    let aes = try AES(key: keyData.bytes, blockMode: ECB(), padding: .pkcs7)
    
    // 解密数据
    let decryptedBytes = try aes.decrypt(encryptedData.bytes)
    
    // 将解密后的数据转换为字符串
    let decryptedData = Data(decryptedBytes)
    return String(data: decryptedData, encoding: .utf8)
}

// Data 扩展以支持十六进制转换
extension String {
    func hexToData() -> Data? {
        var data = Data()
        var hex = self
        if hex.hasPrefix("0x") {
            hex = String(hex.dropFirst(2))
        }
        var index = hex.startIndex
        while index < hex.endIndex {
            let nextIndex = hex.index(index, offsetBy: 2)
            let byteString = String(hex[index..<nextIndex])
            guard let byte = UInt8(byteString, radix: 16) else { return nil }
            data.append(byte)
            index = nextIndex
        }
        return data
    }
}


/**
 
 // 使用示例
 let keyString = "89d91e4c2f35e49322f43e3547917e21"
 let dataString = "123@gmail.com"

 do {
     let encryptedResult = try aesEncryptECB(data: dataString, keyHex: keyString)
     print("Encrypted: \(encryptedResult ?? "Encryption failed")")
 } catch {
     print("Encryption error: \(error)")
 }
 
 // 解密
        if let decryptedText = try aesDecryptECB(encryptedBase64: encryptedBase64, keyHex: keyHex) {
            print("Decrypted: \(decryptedText)")
        }
 */

/// 通用的加密/解密方法
/// - Parameters:
///   - input: 要加密或解密的输入字符串
///   - isEncrypt: 如果为 `true`，执行加密；如果为 `false`，执行解密
/// - Returns: 加密后的 Base64 字符串或解密后的明文字符串
//func processEncryption(input: String, isEncrypt: Bool) -> String? {
//    // 合并密钥字符串
//    let keyString = EncryptionConstants.ENCRYPT_KEY + EncryptionConstants.INIT_VECTOR
//    
//    do {
//        if isEncrypt {
//            // 执行加密操作
//            let encryptedResult = try aesEncryptECB(data: input, keyHex: keyString)
//            print("Encrypted: \(encryptedResult ?? "Encryption failed")")
//            return encryptedResult
//        } else {
//            // 执行解密操作
//            if let decryptedText = try aesDecryptECB(encryptedBase64: input, keyHex: keyString) {
//                print("Decrypted: \(decryptedText)")
//                return decryptedText
//            }
//        }
//    } catch {
//        print("\(isEncrypt ? "Encryption" : "Decryption") error: \(error)")
//    }
//    
//    return nil
//}
//
//// 示例用法：
//// 加密
//let encryptedText = processEncryption(input: "Hello, World!", isEncrypt: true)
//
//// 解密
//let decryptedText = processEncryption(input: encryptedText ?? "", isEncrypt: false)
//
