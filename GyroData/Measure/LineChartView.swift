//
//  MeasureView.swift
//  GyroData
//
//  Created by 신동원 on 2022/09/21.
//

import UIKit

class LineChartView: UIView {
    
    var values: [CGFloat] = []
    
    var graphPath: UIBezierPath!
    var zeroPath: UIBezierPath!
    var animated: Bool!
    
    let graphLayer = CAShapeLayer()

    init(frame: CGRect, values: [CGFloat], animated: Bool) {
        super.init(frame: frame)
        self.values = values
        self.animated = animated
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.graphPath = UIBezierPath()
        self.zeroPath = UIBezierPath()
        
        self.layer.addSublayer(graphLayer)

        let xOffset: CGFloat = self.frame.width / CGFloat(values.count)
        
        var currentX: CGFloat = 0
        let startPosition = CGPoint(x: currentX, y: self.frame.height)
        self.graphPath.move(to: startPosition)
        self.zeroPath.move(to: startPosition)
        
        for i in 0..<values.count {
            currentX += xOffset
            let newPosition = CGPoint(x: currentX,
                                      y: self.frame.height - self.values[i])
            self.graphPath.addLine(to: newPosition)
            self.zeroPath.addLine(to: CGPoint(x: currentX, y: self.frame.height))
        }
        
        graphLayer.fillColor = nil
        graphLayer.strokeColor = UIColor.black.cgColor
        graphLayer.lineWidth = 2
        
        let oldPath = self.zeroPath.cgPath
        let newPath = self.graphPath.cgPath
            
        if self.animated {
            let animation = CABasicAnimation(keyPath: "path")
            animation.duration = 1
            animation.fromValue = oldPath
            animation.toValue = newPath
            self.graphLayer.add(animation, forKey: "path")
        }
        self.graphLayer.path = newPath
    }
}
