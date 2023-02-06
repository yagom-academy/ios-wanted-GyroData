//
//  GraphBackgroundView.swift
//  GyroData
//
//  Created by Victor on 2023/02/05.
//

import UIKit

final class GraphBackgroundView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawBackgroundLines()
    }
}

private extension GraphBackgroundView {
    private func drawBackgroundLines() {
        let horizontalPath = UIBezierPath()
        horizontalPath.lineWidth = 1
        let verticalPath = UIBezierPath()
        verticalPath.lineWidth = 1
        var x: CGFloat = 0.0
        var y: CGFloat = 0.0
        
        let xInterval = bounds.width / CGFloat(8)
        let yInterval = bounds.height / CGFloat(8)
        
        
        for _ in 0...7 {
            horizontalPath.move(to: CGPoint(x: 0, y: y))
            verticalPath.move(to: CGPoint(x: x, y: 0))
            
            horizontalPath.addLine(to: CGPoint(x: bounds.width, y: y))
            verticalPath.addLine(to: CGPoint(x: x, y: bounds.height))
            
            x += xInterval
            y += yInterval
        }
        
        UIColor.black.set()
        horizontalPath.stroke()
        verticalPath.stroke()
    }
}
