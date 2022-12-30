//
//  GraphView.swift
//  GyroData
//
//  Created by Tak on 2022/12/30.
//

import UIKit
import CoreMotion

class GraphView: UIView {
    
//    let calayer = CAShapeLayer()
//    let path = UIBezierPath()
    var values: [CGFloat] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        self.values = values
    }
    
    init(frame: CGRect, values: [CGFloat]) {
        super.init(frame: frame)
        self.values = values
    }
    
    required init?(coder: NSCoder) {
        fatalError("fatalError")
    }
    
//    func drawLine(x: CGFloat, y: CGFloat, color: CGColor) {
//        path.move(to: self.frame.origin)
//        path.addLine(to: CGPoint(x: x, y: y))
//
//        calayer.path = path.cgPath
//        calayer.strokeColor = color
//    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
}
