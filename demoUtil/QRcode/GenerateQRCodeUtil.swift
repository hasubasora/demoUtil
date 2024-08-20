//
//  GenerateQRCodeUtil.swift
//  demoUtil
//
//  Created by 羽柴空 on 2024/07/25.
//

import Foundation
import UIKit
class GenerateQRCodeUtil: UIViewController {
    /// 文字列からQRコードを生成します。
    ///
    /// - Parameter string: QRコードに変換する文字列
    /// - Returns: 生成されたQRコードのイメージ、生成できない場合は nil
    public func generateQRCode(from string: String, withCorrectionLevel level: String = "H") -> UIImage? {
        guard let data = string.data(using: .isoLatin1, allowLossyConversion: false) else {
            return nil
        }
        
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else {
            return nil
        }
        
        qrFilter.setValue(data, forKey: "inputMessage")
        qrFilter.setValue(level, forKey: "inputCorrectionLevel")
        let qrImage = qrFilter.outputImage!
        
        // DPI基準に応じたスケール計算（例：300 DPI）
        let targetDPI: CGFloat = 300.0
        let mmPerInch: CGFloat = 25.4
        let dotSizeMM: CGFloat = 0.381
        let dotsPerMM = targetDPI / mmPerInch
        let scaleFactor = dotsPerMM * dotSizeMM
        let transform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
        let scaledQRImage = qrImage.transformed(by: transform)
        let context = CIContext()
        guard let cgImage = context.createCGImage(scaledQRImage, from: scaledQRImage.extent) else {
            return nil
        }
        return UIImage(cgImage: cgImage)
    }
}
// MARK: - 使用方法
