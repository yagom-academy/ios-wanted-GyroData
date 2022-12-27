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

    private lazy var redLinesLayer = initializeLayer(color: UIColor.red.cgColor)
    private lazy var blueLinesLayer = initializeLayer(color: UIColor.blue.cgColor)
    private lazy var greenLinesLayer = initializeLayer(color: UIColor.green.cgColor)

    override func draw(_ rect: CGRect) {
        let backgroundLayer = initializeBackgroundLayer()
        layer.addSublayer(backgroundLayer)
        [redLinesLayer, blueLinesLayer, greenLinesLayer].forEach {
            self.layer.addSublayer($0)
        }
    }

    func drawGraphFor1Hz(layerType: Layer, value: CGFloat) {
        var layer: CAShapeLayer?

        switch layerType {
        case .red:
            layer = redLinesLayer
        case .blue:
            layer = blueLinesLayer
        case .green:
            layer = greenLinesLayer
        }

        guard let path = layer?.path?.mutableCopy() else { return }
        let nextPoint = CGPoint(x: path.currentPoint.x + widthFor1Hz, y: center.y - value * heightFor1Hz)
        path.addLine(to: nextPoint)
        layer?.path = path
    }

    private func drawPath(from start: CGPoint, to end: CGPoint) -> CGPath {
        let path = CGMutablePath()
        path.move(to: start)
        path.addLine(to: end)
        return path
    }
    
    private func initializeBackgroundLayer() -> CAShapeLayer {
        let backgroud = CAShapeLayer()
        backgroud.lineWidth = 1
        backgroud.strokeColor = UIColor.gray.cgColor
        backgroud.fillColor = UIColor.clear.cgColor
        
        let path = CGMutablePath()
        let verticalSpace = frame.height / CGFloat(viewModel.verticalBackgroundSlice)
        let horizontalSpace = frame.width / CGFloat(viewModel.horizontalBackgroundSlice)
        
        var tempY: CGFloat = verticalSpace
        while tempY < frame.height {
            let startPoint = CGPoint(x: 0, y: tempY)
            let endPoint = CGPoint(x: frame.width, y: tempY)
            path.addPath(drawPath(from: startPoint, to: endPoint))
            tempY += verticalSpace
        }
        
        var tempX: CGFloat = horizontalSpace
        while tempX < frame.height {
            let startPoint = CGPoint(x: tempX, y: 0)
            let endPoint = CGPoint(x: tempX, y: frame.height)
            path.addPath(drawPath(from: startPoint, to: endPoint))
            tempX += horizontalSpace
        }
        
        backgroud.path = path
        return backgroud
    }

    private func initializeLayer(color: CGColor) -> CAShapeLayer {
        let layer = CAShapeLayer()
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: center.y))
        layer.path = path

        layer.lineWidth = 5
        layer.strokeColor = color
        layer.fillColor = UIColor.clear.cgColor
        return layer
    }
}

extension GraphView {
    enum Layer {
        case red
        case blue
        case green
    }
}
