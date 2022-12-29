//
//  UIBezierPath+Extension.swift
//  GyroData
//
//  Created by minsson on 2022/12/29.
//

import UIKit

extension UIBezierPath {
    func drawGraphLine(toX xPoint: CGFloat, toY yPoint: CGFloat, axis: CGFloat) {
        self.addLine(to: CGPoint(x: xPoint, y: axis - yPoint))
    }

    func drawGraph(strideBy pixel: CGFloat, with yPoints: [Double], axisY: CGFloat) {
        var xPoint: CGFloat = 0

        yPoints.forEach { yPoint in
            drawGraphLine(toX: CGFloat(xPoint), toY: yPoint, axis: axisY)
    
            xPoint += pixel
        }
    }
}
