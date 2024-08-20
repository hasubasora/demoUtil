//
//  CircularProgressBar.swift
//  demoUtil
//
//  Created by 羽柴空 on 2024/06/03.
//

import Foundation
import UIKit

class CircularProgressBar: UIView {
    private var progressLayer = CAShapeLayer()
    private var trackLayer = CAShapeLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupProgressBar()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupProgressBar()
    }

    private func setupProgressBar() {
        let circularPath = UIBezierPath(arcCenter: center, radius: 75, startAngle: -CGFloat.pi / 2, endAngle: CGFloat.pi * 1.5, clockwise: true)
        
        // Setup track layer
        trackLayer.path = circularPath.cgPath
        trackLayer.fillColor = UIColor.clear.cgColor
//        trackLayer.strokeColor = UIColor(hexCode: "#636363").cgColor
        trackLayer.lineWidth = 10
        trackLayer.lineCap = .butt
        layer.addSublayer(trackLayer)
        
        // Setup progress layer
        progressLayer.path = circularPath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = UIColor.white.cgColor
        progressLayer.lineWidth = 10
        progressLayer.lineCap = .butt
        progressLayer.strokeEnd = 0
        layer.addSublayer(progressLayer)
    }

    func setProgress(to progress: CGFloat, withAnimation duration: TimeInterval) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = duration
        animation.fromValue = 0
        animation.toValue = progress
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        progressLayer.strokeEnd = progress
        progressLayer.add(animation, forKey: "animateProgress")
    }
}


/**
使用方法  有动画的圈圈进度条
import UIKit

class ViewController: UIViewController {
    
    var progressBar: CircularProgressBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupProgressBar()
        animateProgressBar(to: 0.75, duration: 2.0)
    }
    
    func setupProgressBar() {
        // CircularProgressBarのインスタンスを作成
        progressBar = CircularProgressBar()
        progressBar.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(progressBar)
        
        // CircularProgressBarの制約を設定
        NSLayoutConstraint.activate([
            progressBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            progressBar.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            progressBar.widthAnchor.constraint(equalToConstant: 150),
            progressBar.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    func animateProgressBar(to progress: CGFloat, duration: TimeInterval) {
        progressBar.setProgress(to: progress, withAnimation: duration)
    }
}

*/
