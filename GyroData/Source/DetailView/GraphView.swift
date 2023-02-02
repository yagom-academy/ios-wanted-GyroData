//  GyroData - GraphView.swift
//  Created by zhilly, woong on 2023/02/01

import UIKit

// MARK: - Configure
class GraphView: UIView {
    var xData: [Double] = []

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
    
    func configure(x: Double, y: Double, z: Double) {
        xLabel.text = "x: \(String(format: "%.4f", x))"
        yLabel.text = "y: \(String(format: "%.4f", y))"
        zLabel.text = "z: \(String(format: "%.4f", z))"
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
    
    // TODO: Graph를 하나씩 그리는 메서드
    func drawGraph(data: SensorData) {
        self.xData = data.x
        let path = UIBezierPath()
        let widthSize: Double = Double(self.frame.size.width / 60)
        var startX: Double = 0
        
        path.lineWidth = 1
        path.lineJoinStyle = .miter
        path.usesEvenOddFillRule = true
        UIColor.systemBlue.set()
        path.move(to: CGPoint(x: startX, y: convertDrawingData(item: data.x.last)))
        
        for item in xData {
            let yData = convertDrawingData(item: item)
            print(yData)
            path.addLine(to: CGPoint(x: startX, y: yData))
            startX += widthSize
            path.stroke()
        }
        
        path.stroke()
    }
    
    private func convertDrawingData(item: Double?) -> Double {
        return ((item ?? 0 * -1) * 30) + Double(self.frame.size.height / 2)
    }
}
