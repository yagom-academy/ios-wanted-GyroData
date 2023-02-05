//
//  GraphView.swift
//  GyroData
//
//  Created by junho on 2023/02/01.
//

import UIKit

final class GraphView: UIView {
    private let viewModel = GraphViewModel()
    private lazy var currentPointX = CGPoint(x: .zero, y: frame.height / 2)
    private lazy var currentPointY = CGPoint(x: .zero, y: frame.height / 2)
    private lazy var currentPointZ = CGPoint(x: .zero, y: frame.height / 2)
    private var layerX = CAShapeLayer()
    private var layerY = CAShapeLayer()
    private var layerZ = CAShapeLayer()
    private var gridLayer: CAShapeLayer?
    
    init() {
        super.init(frame: .zero)
        clearGraph()
        viewModel.bind { [weak self] coordinates in
            self?.drawCompleteGraph(coordinates)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
        let layer = createLineLayer(color: UIColor.systemGray.cgColor)
        layer.frame = bounds
        layer.path = path.cgPath
        layer.masksToBounds = true
        setNeedsDisplay()
    }
    
    func drawCompleteGraph(with coordinates: [Coordinate]) {
        viewModel.action(.drawCompleteGraph(with: coordinates))
    }
    
    func configureAxisRange(_ coordinates: [Coordinate]) {
        viewModel.action(.configureAxisRange(with: coordinates))
    }
    
    func updateGraph(with coordinate: Coordinate) {
        viewModel.action(.updateGraph(
            coordinate: coordinate,
            handler: { [weak self] coordinate in
                self?.drawXYZLine(coordinate)
                self?.setNeedsDisplay()
            })
        )
    }
    
    func drawCompleteGraph(_ coordinates: [Coordinate]) {
        removeGraphLines()
        coordinates.forEach { coordinate in
            drawXYZLine(coordinate)
        }
        setNeedsDisplay()
    }
    
    func clearGraph() {
        removeGraphLines()
        setNeedsDisplay()
    }
    
    private func createLineLayer(color: CGColor) -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.lineWidth = 1
        layer.strokeColor = color
        self.layer.addSublayer(layer)
        return layer
    }
    
    private func drawXYZLine(_ coordinate: Coordinate) {
        viewModel.count += 1
        let pointX = CGPoint(x: Double(viewModel.count) / viewModel.maxCount * frame.width, y: calculate(coordinate.x))
        let pointY = CGPoint(x: Double(viewModel.count) / viewModel.maxCount * frame.width, y: calculate(coordinate.y))
        let pointZ = CGPoint(x: Double(viewModel.count) / viewModel.maxCount * frame.width, y: calculate(coordinate.z))
        
        drawLine(by: layerX, from: currentPointX, to: pointX)
        drawLine(by: layerY, from: currentPointY, to: pointY)
        drawLine(by: layerZ, from: currentPointZ, to: pointZ)
        
        currentPointX = pointX
        currentPointY = pointY
        currentPointZ = pointZ
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
    
    private func removeGraphLines() {
        layer.sublayers?.removeAll(where: { layer in
            layer == layerX || layer == layerY || layer == layerZ
        })
        layerX = createLineLayer(color: UIColor.systemRed.cgColor)
        layerY = createLineLayer(color: UIColor.systemGreen.cgColor)
        layerZ = createLineLayer(color: UIColor.systemBlue.cgColor)
        
        viewModel.count = 1.0
        currentPointX = CGPoint(x: .zero, y: frame.height / 2)
        currentPointY = CGPoint(x: .zero, y: frame.height / 2)
        currentPointZ = CGPoint(x: .zero, y: frame.height / 2)
    }
    
    private func calculate(_ y: Double) -> CGFloat {
        let height = frame.height
        let centerY = height / 2
        let axisRange = viewModel.maxValue * 2 * 1.2
        let calculatedY = centerY + CGFloat(y) / axisRange * height
        return calculatedY
    }
}
