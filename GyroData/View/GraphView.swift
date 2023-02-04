//
//  GraphView.swift
//  GyroData
//
//  Created by Jiyoung Lee on 2023/02/01.
//

import UIKit

final class GraphView: UIView {
    private var count = 1.0
    private let maxCount = 600.0
    private lazy var currentPointX = CGPoint(x: .zero, y: frame.height / 2)
    private lazy var currentPointY = CGPoint(x: .zero, y: frame.height / 2)
    private lazy var currentPointZ = CGPoint(x: .zero, y: frame.height / 2)
    private var layerX = CAShapeLayer()
    private var layerY = CAShapeLayer()
    private var layerZ = CAShapeLayer()
    private var gridLayer: CAShapeLayer?
    private var maxValue = 10.0 {
        didSet {
            let scale = oldValue / maxValue
            transformLineLayer(by: scale)
        }
    }

    init() {
        super.init(frame: .zero)
        clearGraph()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func calculateY(_ y: Double) -> CGFloat {
        let height = frame.height
        let centerY = height / 2
        let axisRange = maxValue * 2
        let calculatedY = centerY + CGFloat(y) / axisRange * height
        return calculatedY
    }

    private func transformLineLayer(by scale: CGFloat) {
        layerX.transform = CATransform3DMakeScale(1, scale, 1)
        layerY.transform = CATransform3DMakeScale(1, scale, 1)
        layerZ.transform = CATransform3DMakeScale(1, scale, 1)
        currentPointX.y = currentPointX.y * scale
        currentPointY.y = currentPointY.y * scale
        currentPointZ.y = currentPointZ.y * scale
        setNeedsDisplay()
    }

    private func drawLine(by lineLayer: CAShapeLayer, from start: CGPoint?, to end: CGPoint) {
        guard let start else { return }
        let path: UIBezierPath
        if let cgPath = lineLayer.path {
            path = UIBezierPath(cgPath: cgPath)
        } else {
            path = UIBezierPath()
        }
        path.move(to: start)
        path.addLine(to: end)
        lineLayer.frame = bounds
        lineLayer.path = path.cgPath
    }

    func drawGrid() {
        layer.borderColor = UIColor.systemGray.cgColor
        layer.borderWidth = 1

        let width: Int = Int(bounds.width)
        let fraction: Int = Int(bounds.width) / 8
        let path = UIBezierPath()
        for i in 1..<8 {
            path.move(to: CGPoint(x: .zero, y: fraction * i))
            path.addLine(to: CGPoint(x: width, y: fraction * i))
            path.move(to: CGPoint(x: fraction * i, y: .zero))
            path.addLine(to: CGPoint(x: fraction * i, y: width))
        }

        let layer = CAShapeLayer()
        layer.lineWidth = 1
        layer.frame = bounds
        layer.path = path.cgPath
        layer.strokeColor = UIColor.systemGray.cgColor
        self.layer.addSublayer(layer)
        layer.masksToBounds = true
        setNeedsDisplay()
    }

    private func createLineLayer(color: CGColor) -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.lineWidth = 1
        layer.lineCap = .round
        layer.strokeColor = color
        self.layer.addSublayer(layer)
        return layer
    }

    private func axisRangeNeedsUpdate(_ coordinate: Coordinate) {
        var maxValue = max(coordinate.x, coordinate.y, coordinate.z)
        let minValue = min(coordinate.x, coordinate.y, coordinate.z)
        maxValue = max(maxValue, abs(minValue))
        if maxValue > self.maxValue { self.maxValue = maxValue }
    }

    func clearGraph() {
        layer.sublayers?.removeAll(where: { layer in
            layer == layerX || layer == layerY || layer == layerZ
        })
        layerX = createLineLayer(color: UIColor.systemRed.cgColor)
        layerY = createLineLayer(color: UIColor.systemGreen.cgColor)
        layerZ = createLineLayer(color: UIColor.systemBlue.cgColor)
        setNeedsDisplay()

        count = 1.0
        currentPointX = CGPoint(x: .zero, y: frame.height / 2)
        currentPointY = CGPoint(x: .zero, y: frame.height / 2)
        currentPointZ = CGPoint(x: .zero, y: frame.height / 2)
    }

    func drawChartLine(_ coordinate: Coordinate) {
        count += 1
        axisRangeNeedsUpdate(coordinate)

        let pointX = CGPoint(x: Double(count) / maxCount * frame.width, y: calculateY(coordinate.x))
        let pointY = CGPoint(x: Double(count) / maxCount * frame.width, y: calculateY(coordinate.y))
        let pointZ = CGPoint(x: Double(count) / maxCount * frame.width, y: calculateY(coordinate.z))

        drawLine(by: layerX, from: currentPointX, to: pointX)
        drawLine(by: layerY, from: currentPointY, to: pointY)
        drawLine(by: layerZ, from: currentPointZ, to: pointZ)
        setNeedsDisplay()

        currentPointX = pointX
        currentPointY = pointY
        currentPointZ = pointZ
    }
}
