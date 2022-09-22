//
//  GraphView.swift
//  GyroData
//
//  Created by 김지인 on 2022/09/22.
//

import UIKit

final class GraphView: UIView {
    
    override func draw(_ rect: CGRect) {
        
        startAnimation()
    
    }
    
    func startAnimation() {
        let x = UIBezierPath()
        //design
        x.move(to: CGPoint(x: 0, y: self.frame.height / 2))
        x.addLine(to: CGPoint(x: 11, y: 22))
        x.addLine(to: CGPoint(x: 40, y: 50))
        x.addLine(to: CGPoint(x: 50, y: 20))
        
        let y = UIBezierPath()
        y.move(to: CGPoint(x: 0, y: self.frame.height / 2))
        y.addLine(to: CGPoint(x: 40, y: 90))
        y.addLine(to: CGPoint(x: 50, y: 20))
        y.addLine(to: CGPoint(x: 60, y: 30))
        
        let z = UIBezierPath()
        z.move(to: CGPoint(x: 0, y: self.frame.height / 2))
        z.addLine(to: CGPoint(x: 60, y: 90))
        z.addLine(to: CGPoint(x: 70, y: 20))
        z.addLine(to: CGPoint(x: 80, y: 30))
        
        let layerX = CAShapeLayer()
        layerX.path = x.cgPath
        shapeLayerDesign(layerX, color: .yellow)
        self.layer.addSublayer(layerX)
        
        let layerY = CAShapeLayer()
        layerY.path = y.cgPath
        shapeLayerDesign(layerY, color: .blue)
        self.layer.addSublayer(layerY)
        
        let layerZ = CAShapeLayer()
        layerZ.path = z.cgPath
        shapeLayerDesign(layerZ, color: .green)
        self.layer.addSublayer(layerZ)

        let animation = CABasicAnimation(keyPath: "strokeEnd") //path의 끝점
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 2

        layerX.add(animation, forKey: animation.keyPath)
        layerY.add(animation, forKey: animation.keyPath)
        layerZ.add(animation, forKey: animation.keyPath)

    }
    
    func shapeLayerDesign(_ layer: CAShapeLayer, color: UIColor) {
        layer.frame = bounds
        layer.strokeColor = color.cgColor
        layer.fillColor = UIColor.clear.cgColor
        layer.lineWidth = 5
        layer.lineJoin = .round
        layer.lineCap = .round
    }
}

