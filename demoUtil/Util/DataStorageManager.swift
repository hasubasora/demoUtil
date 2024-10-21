//
//  DataStorageManager.swift
//
//  Created by CHEN YONGHAN on 2024/1/3.
//
//  このクラスはアプリケーションデータの保存、取得、削除を行うためのユーティリティを提供します。
//  主にUserDefaultsを使用してデータを格納し、キーをベースに操作します。
//


import Foundation
/// 指定されたアクションに基づいて保存データを操作します。
///
/// - Parameters:
///   - action: 実行するアクションの種類（"has", "save", "remove", "get"）
///   - values: アクションに関連する値（オプション、保存時のみ必要）
///   - key: データを格納または取得するためのキー
/// - Returns: 操作結果に関連する値（存在するかどうかのチェックや取得の場合）
public func operateStoredData(action: String, storedValues values: String? = nil, forKey key: String) -> Any? {
    switch action {
    case "has":
        // 指定されたキーが存在するかどうかを確認
        return UserDefaults.standard.object(forKey: key) != nil
    case "save":
        // 値を保存
        guard let values = values else {
            return nil
        }
        UserDefaults.standard.setValue(values, forKey: key)
    case "remove":
        // キーに関連付けられたデータを削除
        UserDefaults.standard.removeObject(forKey: key)
    case "get":
        // 値を取得
        return UserDefaults.standard.string(forKey: key)
    default:
        return nil
    }
    return nil
}

/// 配列形式の保存データを操作します。
///
/// - Parameters:
///   - action: 実行するアクションの種類（"has", "save", "remove", "get"）
///   - values: 保存する配列データ（オプション、保存時のみ必要）
///   - key: データを格納または取得するためのキー
/// - Returns: 操作結果に関連する配列データ（取得時の場合）
public func operateStoredArrData(action: String, storedValues values: [[String: String]]? = nil, forKey key: String) -> Any? {
    switch action {
    case "has":
        // キーが存在するかどうかを確認
        return UserDefaults.standard.object(forKey: key) != nil
    case "save":
        // 配列データを保存
        guard let values = values else {
            return nil
        }
        do {
            let data = try JSONSerialization.data(withJSONObject: values, options: [])
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print("保存に失敗しました: \(error.localizedDescription)")
        }
    case "remove":
        // データを削除
        UserDefaults.standard.removeObject(forKey: key)
    case "get":
        // 保存された配列データを取得
        if let data = UserDefaults.standard.data(forKey: key) {
            do {
                let array = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: String]]
                return array
            } catch {
                print("データの取得に失敗しました: \(error.localizedDescription)")
                return nil
            }
        }
    default:
        return nil
    }
    return nil
}
