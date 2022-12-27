//
//  GraphView.swift
//  GyroData
//
//  Created by 천수현 on 2022/12/27.
//

import UIKit

final class GraphView: UIView {
    private var viewModel = GraphViewModel()

    private var widthFor1Hz: CGFloat {
        return self.frame.width / viewModel.xScale
    }

    private var heightFor1Hz: CGFloat {
        return self.frame.height / viewModel.yScale
    }

    private var path = CGMutablePath()
    private var linesLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.lineWidth = 5
        layer.strokeColor = UIColor.systemYellow.cgColor
        layer.fillColor = UIColor.clear.cgColor
        return layer
    }()

    override func draw(_ rect: CGRect) {
        path.move(to: CGPoint(x: 0, y: center.y))
        drawGraphFor1Hz(value: 1)
        drawGraphFor1Hz(value: 4)
        drawGraphFor1Hz(value: -4)
        linesLayer.path = path
        layer.addSublayer(linesLayer)
    }

    private func drawGraphFor1Hz(value: CGFloat) {
        let nextPoint = CGPoint(x: path.currentPoint.x + widthFor1Hz, y: center.y - value * heightFor1Hz)
        path.addLine(to: nextPoint)
        linesLayer.path = path
    }
}
