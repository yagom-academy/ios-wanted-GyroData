//
//  GraphView.swift
//  GyroData
//
//  Created by Jiyoung Lee on 2023/02/01.
//

import UIKit

class GraphView: UIView {
    private let maxCount: Double = 600
    private lazy var currentX: CGPoint = CGPoint(x: .zero, y: self.frame.height / 2)
    private lazy var currentY: CGPoint = CGPoint(x: .zero, y: self.frame.height / 2)
    private lazy var currentZ: CGPoint = CGPoint(x: .zero, y: self.frame.height / 2)
    private var count: Double = 0
    private var maxValue: Double = 10 {
        didSet {
            minValue = min(minValue, -maxValue)
        }
    }
    private var minValue: Double = -10 {
        didSet {
            maxValue = max(maxValue, -minValue)
        }
    }

    private func calculateY(_ y: Double) -> CGFloat {
        let height = frame.height
        let centerY = height / 2
        let axisRange = maxValue - minValue
        let calculatedY = centerY + CGFloat(y) / axisRange * height
        return calculatedY
    }

    private func drawBezier(from start: CGPoint, to end: CGPoint, color: CGColor) {
        let path = UIBezierPath()
        path.move(to: start)
        path.addLine(to: end)
        let lineLayer = CAShapeLayer()
        lineLayer.lineWidth = 1
        lineLayer.lineCap = .round
        lineLayer.frame = bounds
        lineLayer.path = path.cgPath
        lineLayer.strokeColor = color
        self.layer.addSublayer(lineLayer)
        self.setNeedsDisplay()
    }

    func drawChartLine(_ coordinate: Coordinate) {
        count += 1
        let pointX = CGPoint(
            x: count / maxCount * frame.width,
            y: calculateY(coordinate.x)
        )
        let pointY = CGPoint(
            x: count / maxCount * frame.width,
            y: calculateY(coordinate.y)
        )
        let pointZ = CGPoint(
            x: count / maxCount * frame.width,
            y: calculateY(coordinate.z)
        )

        drawBezier(
            from: currentX,
            to: pointX,
            color: UIColor.systemRed.cgColor
        )
        drawBezier(
            from: currentY,
            to: pointY,
            color: UIColor.systemGreen.cgColor
        )
        drawBezier(from: currentZ,
                   to: pointZ,
                   color: UIColor.systemBlue.cgColor
        )

        self.currentX = pointX
        self.currentY = pointY
        self.currentZ = pointZ
    }
}
