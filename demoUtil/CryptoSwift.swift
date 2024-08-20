//import Foundation
//import CryptoSwift
//
//// AES encryption function
//func encrypt(text: String, key: String, iv: String) -> String? {
//    do {
//        let aes = try AES(key: key.bytes, blockMode: CBC(iv: iv.bytes), padding: .pkcs7)
//        let encrypted = try aes.encrypt(text.bytes)
//        return encrypted.toBase64()
//    } catch {
//        print("Error encrypting: \(error)")
//        return nil
//    }
//}
//
//// Function to make GET request with encrypted parameters
//func makeGetRequest(name: String, password: String) {
//    let key = "yourAESKey123456" // 16 bytes for AES-128
//    let iv = "yourAESIV12345678" // 16 bytes
//
//    guard let encryptedName = encrypt(text: name, key: key, iv: iv),
//          let encryptedPassword = encrypt(text: password, key: key, iv: iv) else {
//        print("Encryption failed")
//        return
//    }
//
//    let urlString = "https://yourapi.com/endpoint?name=\(encryptedName)&password=\(encryptedPassword)"
//    
//    guard let url = URL(string: urlString) else {
//        print("Invalid URL")
//        return
//    }
//
//    var request = URLRequest(url: url)
//    request.httpMethod = "GET"
//
//    let task = URLSession.shared.dataTask(with: request) { data, response, error in
//        if let error = error {
//            print("Error making GET request: \(error)")
//            return
//        }
//        
//        guard let data = data else {
//            print("No data received")
//            return
//        }
//
//        if let httpResponse = response as? HTTPURLResponse {
//            print("HTTP Response Status Code: \(httpResponse.statusCode)")
//        }
//
//        let responseString = String(data: data, encoding: .utf8)
//        print("Response: \(responseString ?? "")")
//    }
//
//    task.resume()
//}
//
//// Usage example
//makeGetRequest(name: "yourName", password: "yourPassword")
