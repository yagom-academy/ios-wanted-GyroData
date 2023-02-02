//  GyroData - GraphView.swift
//  Created by zhilly, woong on 2023/02/01

import UIKit

// MARK: - Configure
class GraphView: UIView {
    
    private var startX: Double = 0
    
    private var currentX: Double = 0
    private var currentY: Double = 0
    private var currentZ: Double = 0
    
    private let xLabel: UILabel = {
        let label = UILabel()
        
        label.text = "x:"
        label.textColor = .red
        
        return label
    }()
    
    private let yLabel: UILabel = {
        let label = UILabel()
        
        label.text = "y:"
        label.textColor = .green
        
        return label
    }()
    
    private let zLabel: UILabel = {
        let label = UILabel()
        
        label.text = "z:"
        label.textColor = .blue
        
        return label
    }()
    
    private let axisLabelStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    init() {
        super.init(frame: .zero)
        setupViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawGrid()
    }
    
    private func setupViews() {
        [xLabel, yLabel, zLabel].forEach(axisLabelStackView.addArrangedSubview(_:))
        self.addSubview(axisLabelStackView)
        
        NSLayoutConstraint.activate([
            axisLabelStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            axisLabelStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            axisLabelStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8)
        ])
    }
    
    func configure(xPoint: Double?, yPoint: Double?, zPoint: Double?) {
        xLabel.text = "x: \(String(format: "%.4f", xPoint ?? 0))"
        yLabel.text = "y: \(String(format: "%.4f", yPoint ?? 0))"
        zLabel.text = "z: \(String(format: "%.4f", zPoint ?? 0))"
    }
}

// MARK: - Draw
extension GraphView {
    private func drawGrid() {
        let gridWidth = self.frame.size.width / 8
        let gridPath = UIBezierPath()
        
        var pointLeft = CGPoint(x: 0, y: gridWidth)
        var pointRight = CGPoint(x: bounds.size.width, y: gridWidth)
        
        while pointLeft.y < bounds.height {
            gridPath.move(to: pointLeft)
            gridPath.addLine(to: pointRight)
            pointLeft.y = pointLeft.y + gridWidth
            pointRight.y = pointRight.y + gridWidth
        }
        
        var pointTop = CGPoint(x: gridWidth, y: 0)
        var pointBottom = CGPoint(x: gridWidth, y: bounds.size.height)
        
        while pointTop.x < bounds.width {
            gridPath.move(to: pointTop)
            gridPath.addLine(to: pointBottom)
            pointTop.x = pointTop.x + gridWidth
            pointBottom.x = pointBottom.x + gridWidth
        }
        
        let gridLayer = CAShapeLayer()
        
        gridLayer.frame = bounds
        gridLayer.path = gridPath.cgPath
        gridLayer.strokeColor = UIColor.black.cgColor
        gridLayer.lineWidth = 0.4
        
        layer.addSublayer(gridLayer)
    }
    
    func drawGraph(data: [Double], color: CGColor) {
        let path = UIBezierPath()
        let layer = CAShapeLayer()
        
        let widthSize: Double = Double(self.frame.size.width / 600)
        var startPoint: Double = 0
        
        path.move(to: CGPoint(x: startPoint, y: convertDrawingData(item: data.first)))
        
        for item in data {
            let drawingData = convertDrawingData(item: item)
            path.addLine(to: CGPoint(x: startPoint, y: drawingData))
            startPoint += widthSize
            layer.path = path.cgPath
            layer.fillColor = nil
            layer.strokeColor = color
        }
        
        self.layer.addSublayer(layer)
        
    }
    
    func drawLine(xPoint: Double?, yPoint: Double?, zPoint: Double?) {
        guard let xPoint = xPoint,
              let yPoint = yPoint,
              let zPoint = zPoint else { return }
        
        addLine(currentPoint: currentX, targetPoint: xPoint, color: UIColor.red.cgColor)
        addLine(currentPoint: currentY, targetPoint: yPoint, color: UIColor.green.cgColor)
        addLine(currentPoint: currentZ, targetPoint: zPoint, color: UIColor.blue.cgColor)
        
        self.currentX = xPoint
        self.currentY = yPoint
        self.currentZ = zPoint
        
        self.startX += Double(self.frame.size.width / 600)
    }
    
    private func addLine(currentPoint: Double, targetPoint: Double, color: CGColor) {
        let path = UIBezierPath()
        let layer = CAShapeLayer()
        layer.name = "ChartData"
        let widthSize: Double = Double(self.frame.size.width / 600)
        
        path.lineWidth = 0
        path.move(to: CGPoint(x: startX, y: convertDrawingData(item: currentPoint)))
        path.addLine(to: CGPoint(x: startX + widthSize, y: convertDrawingData(item: targetPoint)))
        
        layer.path = path.cgPath
        layer.fillColor = nil
        layer.strokeColor = color
        
        self.layer.addSublayer(layer)
    }
    
    private func convertDrawingData(item: Double?) -> Double {
        return ((item ?? 0 * -1) * 15) + Double(self.frame.size.height / 2)
    }
    
    func resetView() {
        startX = 0
        currentX = 0
        currentY = 0
        currentZ = 0
        
        guard let layers = layer.sublayers else { return }
        
        layers.forEach { layer in
            if layer.name == "ChartData" {
                layer.removeFromSuperlayer()
            }
        }
    }
}
