import UIKit

class CupView: UIView {
    var waterHeight: CGFloat = 150 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        let topWidth: CGFloat = 250
        let bottomWidth: CGFloat = 200
        let height: CGFloat = 400
        let cornerRadius: CGFloat = 5

        let topLeft = CGPoint(x: rect.midX - topWidth / 2, y: rect.minY)
        let topRight = CGPoint(x: rect.midX + topWidth / 2, y: rect.minY)
        let bottomLeft = CGPoint(x: rect.midX - bottomWidth / 2, y: rect.minY + height)
        let bottomRight = CGPoint(x: rect.midX + bottomWidth / 2, y: rect.minY + height)

        let cupPath = UIBezierPath()
            cupPath.move(to: CGPoint(x: topLeft.x + cornerRadius, y: topLeft.y))
            cupPath.addLine(to: CGPoint(x: topRight.x - cornerRadius, y: topRight.y))
            cupPath.addArc(withCenter: CGPoint(x: topRight.x - cornerRadius, y: topRight.y + cornerRadius),
                           radius: cornerRadius, startAngle: CGFloat(3 * Double.pi / 2), endAngle: 0, clockwise: true)
            cupPath.addLine(to: CGPoint(x: bottomRight.x, y: bottomRight.y - cornerRadius))
            cupPath.addArc(withCenter: CGPoint(x: bottomRight.x - cornerRadius, y: bottomRight.y - cornerRadius),
                           radius: cornerRadius, startAngle: 0, endAngle: CGFloat(Double.pi / 2), clockwise: true)
            cupPath.addLine(to: CGPoint(x: bottomLeft.x + cornerRadius, y: bottomLeft.y))
            cupPath.addArc(withCenter: CGPoint(x: bottomLeft.x + cornerRadius, y: bottomLeft.y - cornerRadius),
                           radius: cornerRadius, startAngle: CGFloat(Double.pi / 2), endAngle: CGFloat(Double.pi), clockwise: true)
            cupPath.addLine(to: CGPoint(x: topLeft.x, y: topLeft.y + cornerRadius))
            cupPath.addArc(withCenter: CGPoint(x: topLeft.x + cornerRadius, y: topLeft.y + cornerRadius),
                           radius: cornerRadius, startAngle: CGFloat(Double.pi), endAngle: CGFloat(3 * Double.pi / 2), clockwise: true)
            
        
        // Draw the cup outline
        context.addPath(cupPath.cgPath)
        context.setStrokeColor(UIColor.blue.cgColor)
        context.setLineWidth(2)
        context.strokePath()
        
        // Clip to the cup path
        context.addPath(cupPath.cgPath)
        context.clip()
        
        // Draw the water
        let waterLevel = rect.minY + height - waterHeight
        let waterTopLeft = CGPoint(x: rect.midX - topWidth / 2, y: waterLevel)
        let waterTopRight = CGPoint(x: rect.midX + topWidth / 2, y: waterLevel)
        
//        let waterPath = UIBezierPath()
//        waterPath.move(to: waterTopLeft)
//        waterPath.addLine(to: waterTopRight)
//        waterPath.addQuadCurve(to: bottomRight, controlPoint: CGPoint(x: rect.midX + topWidth / 2, y: rect.minY + height))
//        waterPath.addLine(to: bottomLeft)
//        waterPath.addQuadCurve(to: waterTopLeft, controlPoint: CGPoint(x: rect.midX - topWidth / 2, y: rect.minY + height))
//
//        context.addPath(waterPath.cgPath)
//        context.setFillColor(UIColor.blue.withAlphaComponent(0.3).cgColor)
//        context.fillPath()
        
        // 绘制水的路径
        let waterPath = UIBezierPath()
        waterPath.move(to: waterTopLeft)
        waterPath.addLine(to: waterTopRight)
        waterPath.addLine(to: bottomRight)
        waterPath.addLine(to: bottomLeft)
        waterPath.addLine(to: waterTopLeft)

        // 创建水的填充颜色
        context.saveGState()
        context.addPath(waterPath.cgPath)
        context.setFillColor(UIColor.blue.withAlphaComponent(0.3).cgColor)
        context.fillPath()
        context.restoreGState()

        // 添加左侧高光反光效果
        context.saveGState()
        context.translateBy(x: 20, y: 14)  // 向右移动 20 像素
        context.rotate(by: CGFloat( -5 * Double.pi / 180))  // 旋转 45 度

        let highlightPath = UIBezierPath()
        let highlightWidth: CGFloat = 80

        highlightPath.move(to: CGPoint(x: waterTopLeft.x , y: waterTopLeft.y - 7))
        highlightPath.addLine(to: CGPoint(x: waterTopLeft.x + highlightWidth, y: waterTopLeft.y))
        highlightPath.addLine(to: CGPoint(x: waterTopLeft.x + highlightWidth, y: bottomLeft.y))
        highlightPath.addLine(to: CGPoint(x: waterTopLeft.x  , y: bottomLeft.y - 7 ))
        highlightPath.close()

        // 创建高光渐变
        let highlightColors = [
            UIColor.white.withAlphaComponent(0.1).cgColor,
            UIColor.white.withAlphaComponent(0.9).cgColor,
            UIColor.white.withAlphaComponent(0.1).cgColor,
        ]
        let highlightLocations: [CGFloat] = [0.0, 0.4, 1.0] // 调整高光的宽度
        guard let highlightGradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: highlightColors as CFArray, locations: highlightLocations) else { return }

        context.addPath(highlightPath.cgPath)
        context.clip()
        context.drawLinearGradient(
            highlightGradient,
            start: CGPoint(x: waterTopLeft.x , y: waterTopLeft.y),
            end: CGPoint(x: waterTopLeft.x + highlightWidth, y: waterTopLeft.y),
            options: [])
        context.restoreGState()
    }
}

class CupControllerView: UIViewController {
    private let cupView = CupView()
    private let slider = UISlider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        // Setup cup view
        cupView.frame = CGRect(x: 0, y: 100, width: view.bounds.width, height: 400)
        cupView.backgroundColor = .clear
        view.addSubview(cupView)
        
        // Setup slider
        slider.frame = CGRect(x: 20, y: 520, width: view.bounds.width - 40, height: 40)
        slider.minimumValue = 0
        slider.maximumValue = 300
        slider.value = 150
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        view.addSubview(slider)
    }
    
    @objc private func sliderValueChanged(_ sender: UISlider) {
        cupView.waterHeight = CGFloat(sender.value)
    }
}

