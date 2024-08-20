//
//  Generate128BarcodeUtil.swift
//  CoreApp
//
//  Created by CHEN YONGHAN on 2024/1/3.
//

import UIKit

class Generate128BarcodeUtil: UIViewController {
    /// 指定されたテキストを使用して、サイズを指定したバーコード128を生成します。
    ///
    /// - Parameters:
    ///   - text: バーコードにエンコードするテキスト
    ///   - size: バーコードのサイズ
    /// - Returns: 生成されたバーコードの画像、もしくはnil
    public func generateConsistentCode128Barcode(from string: String, width: CGFloat, height: CGFloat) -> UIImage? {
        let data = string.data(using: .ascii)
        
        // バーコード生成フィルタを作成
        guard let filter = CIFilter(name: "CICode128BarcodeGenerator") else { return nil }
        filter.setValue(data, forKey: "inputMessage")
        
        // フィルタから生成された画像を取得
        guard let ciImage = filter.outputImage else { return nil }
        
        // 高解像度処理
        let barcodeImage = createNonInterpolatedUIImageFormCIImage(image: ciImage, size: CGSize(width: width, height: height - 80))
        
        // 白背景を透明にする
        let transparentBarcodeImage = barcodeImage.imageByRemoveWhiteBg()
        
        // 最終画像を作成し、テキストを追加する
        let size = CGSize(width: width, height: height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        // 背景を透明に設定
        UIColor.clear.set()
        UIRectFill(CGRect(origin: .zero, size: size))
        
        // バーコード画像を描画
        transparentBarcodeImage?.draw(in: CGRect(x: 0, y: 0, width: width, height: height - 80))
        
        // テキストを描画
        let separatedString = string.enumerated().map { index, char in
            return (index != 0 && (index + 1) % 4 == 0 && index != string.count - 1) ? "\(char) " : "\(char)"
        }.joined()
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 80),
            .paragraphStyle: paragraphStyle,
            .foregroundColor: UIColor.black
        ]
        let textRect = CGRect(x: 0, y: height - 160, width: width, height: 80)
        separatedString.draw(in: textRect, withAttributes: attributes)
        
        // 最終画像を取得
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return finalImage
    }

    // 高解像度のUIImageを生成
    func createNonInterpolatedUIImageFormCIImage(image: CIImage, size: CGSize) -> UIImage {
        let extent: CGRect = image.extent.integral
        let scale: CGFloat = min(size.width / extent.width, size.height / extent.height)
        
        let width = extent.width * scale
        let height = extent.height * scale
        
        let cs: CGColorSpace = CGColorSpaceCreateDeviceGray()
        let bitmapRef = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: cs, bitmapInfo: 0)!
        
        let context = CIContext(options: nil)
        let bitmapImage: CGImage = context.createCGImage(image, from: extent)!
        
        bitmapRef.interpolationQuality = .none
        bitmapRef.scaleBy(x: scale, y: scale)
        bitmapRef.draw(bitmapImage, in: extent)
        
        let scaledImage: CGImage = bitmapRef.makeImage()!
        return UIImage(cgImage: scaledImage)
    }
}
// UIImage拡張
extension UIImage {
    // 白背景を透明にする
    func imageByRemoveWhiteBg() -> UIImage? {
        let colorMasking: [CGFloat] = [222, 255, 222, 255, 222, 255]
        return transparentColor(colorMasking: colorMasking)
    }
    
    // 指定した色を透明にする
    func transparentColor(colorMasking: [CGFloat]) -> UIImage? {
        if let rawImageRef = self.cgImage {
            UIGraphicsBeginImageContext(self.size)
            if let maskedImageRef = rawImageRef.copy(maskingColorComponents: colorMasking) {
                let context: CGContext = UIGraphicsGetCurrentContext()!
                context.translateBy(x: 0.0, y: self.size.height)
                context.scaleBy(x: 1.0, y: -1.0)
                context.draw(maskedImageRef, in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
                let result = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                return result
            }
        }
        return nil
    }
}
// MARK: - 使用方法

//
//if let barcodeImage = self.codeTool.generateConsistentCode128Barcode(from: "0000111122223333", width: 1800, height: 700) {
//        DispatchQueue.main.async {
//            self.generateBarcodeImage.image = barcodeImage
//            self.generateBarcodeImage.contentMode = .scaleAspectFit  // アスペクト比を保持して表示
//        }
//}
