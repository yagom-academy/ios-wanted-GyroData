//
//  GraphView.swift
//  GyroData
//
//  Copyright (c) 2023 Jeremy All rights reserved.


import UIKit

class GraphView: UIView {
    private var line = [CGPoint]()
    private var currentX: CGFloat = .zero
    private let lineWidth: CGFloat = 2
    private let lineColor: CGColor = UIColor.red.cgColor
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setStrokeColor(lineColor)
        context.setLineWidth(lineWidth)
        context.setLineCap(.round)
        context.setLineJoin(.round)
        
        for (index, point) in line.enumerated() {
            if index == 0 {
                context.move(to: point)
            } else {
                context.addLine(to: point)
            }
        }
        context.strokePath()
    }
    
    func addGraphLine(y: CGFloat) {
        let lastPoint: CGPoint = line.last ?? .zero
        let currentPoint = CGPoint(x: currentX, y: halfHeight + y)
        currentX += 1
        line.append(currentPoint)
        
        let rect = calculateRectBetween(lastPoint: lastPoint, newPoint: currentPoint)
        setNeedsDisplay(rect)
    }
    
    private func calculateRectBetween(lastPoint: CGPoint, newPoint: CGPoint) -> CGRect {
        let originX = min(lastPoint.x, newPoint.x) - (lineWidth * 0.5)
        let originY = min(lastPoint.y, newPoint.y) - (lineWidth * 0.5)
        
        let maxX = max(lastPoint.x, newPoint.x) + (lineWidth * 0.5)
        let maxY = max(lastPoint.y, newPoint.y) + (lineWidth * 0.5)
        
        let width = maxX - originX
        let height = maxY - originY
        
        return CGRect(x: originX, y: originY, width: width, height: height)
    }
}

fileprivate extension UIView {
    var halfHeight: Double {
        return self.frame.width * 0.5
    }
}
