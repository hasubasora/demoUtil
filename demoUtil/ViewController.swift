import UIKit
import CryptoSwift

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 使用示例
        let keyString = "89d91e4c2f35e49322f43e3547917e21"
        let dataString = "123@gmail.com"

        do {
            let encryptedResult = try aesEncryptECB(data: dataString, keyHex: keyString)
            print("Encrypted: \(encryptedResult ?? "Encryption failed")")
            // 解密
            if let decryptedText = try aesDecryptECB(encryptedBase64: encryptedResult!, keyHex: keyString) {
                print("Decrypted: \(decryptedText)")
            }
        } catch {
            print("Encryption error: \(error)")
        }
        
     
    }


}

