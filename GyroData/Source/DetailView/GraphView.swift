//  GyroData - GraphView.swift
//  Created by zhilly, woong on 2023/02/01

import UIKit

// MARK: - Configure
class GraphView: UIView {
    lazy var widthSize: Double = Double(self.frame.size.width / 600)
    var startX: Double = 0
    
    var currentX: Double = 0
    var currentY: Double = 0
    var currentZ: Double = 0


    let xLabel: UILabel = {
        let label = UILabel()
        
        label.text = "x:"
        label.textColor = .red
        
        return label
    }()
    
    let yLabel: UILabel = {
        let label = UILabel()
        
        label.text = "y:"
        label.textColor = .green
        
        return label
    }()
    
    let zLabel: UILabel = {
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
    
    func configure(label: UILabel, type: String, value: Double) {
        label.text = "\(type): \(String(format: "%.4f", value))"
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
    
    // TODO: Graph를 한번에 그리는 메서드
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
    
    // TODO: Graph를 하나씩 그리는 메서드
    
    func drawLine(x: Double, y: Double, z: Double) {
        drawLine2(targetPoint: x, currentPoint: currentX, color: UIColor.red.cgColor)
        drawLine2(targetPoint: y, currentPoint: currentY, color: UIColor.green.cgColor)
        drawLine2(targetPoint: z, currentPoint: currentZ, color: UIColor.blue.cgColor)
        
        startX += widthSize
    }
    
    func drawLine2(targetPoint: Double, currentPoint: Double, color: CGColor) {
        let path = UIBezierPath()
        let layer = CAShapeLayer()
        
        path.move(to: CGPoint(x: startX, y: currentPoint))
        path.addLine(to: CGPoint(x: startX + widthSize, y: targetPoint))
        layer.path = path.cgPath
        layer.fillColor = nil
        layer.strokeColor = color
        self.layer.addSublayer(layer)
    }
    
    private func convertDrawingData(item: Double?) -> Double {
        return ((item ?? 0 * -1) * 15) + Double(self.frame.size.height / 2)
    }
}
