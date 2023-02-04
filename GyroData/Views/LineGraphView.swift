//
//  LineGraphView.swift
//  GyroData
//
//  Created by 로빈 on 2023/01/30.
//

import UIKit

final class LineGraphView: UIView {
    
    private let axisXLabel = UILabel(text: "x: 0", textColor: .red, textAlignment: .center)
    private let axisYLabel = UILabel(text: "y: 0", textColor: .green, textAlignment: .center)
    private let axisZLabel = UILabel(text: "z: 0", textColor: .blue, textAlignment: .center)
    private let stackView = UIStackView(distribution: .fillEqually)
    
    private var data: [AxisValue] = [] {
        didSet {
            setNeedsDisplay()
        }
    }
    
    init(data: [AxisValue] = []) {
        self.data = data
        super.init(frame: .zero)
        
        backgroundColor = .white
        configureView()
        configureConstraints()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        drawGrid(column: 8, row: 8)
        drawGraph()
    }
    
    func setData(_ data: [AxisValue]) {
        self.data = data
    }
    
    func addData(_ data: AxisValue) {
        self.data.append(data)
    }
    
    private func configureLabel(with data: AxisValue) {
        axisXLabel.text = String(Int(data.x * 1000))
        axisYLabel.text = String(Int(data.y * 1000))
        axisZLabel.text = String(Int(data.z * 1000))
    }
    
    private func drawGrid(column: Int, row: Int) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.setStrokeColor(UIColor.lightGray.cgColor)
        context.setLineWidth(0.5)
        
        for i in 1...column {
            let y = frame.height / CGFloat(column) * CGFloat(i)
            context.move(to: CGPoint(x: 0, y: y))
            context.addLine(to: CGPoint(x: frame.width, y: y))
        }
        
        context.strokePath()
        
        for i in 1...row {
            let x = frame.width / CGFloat(row) * CGFloat(i)
            context.move(to: CGPoint(x: x, y: 0))
            context.addLine(to: CGPoint(x: x, y: frame.height))
        }
        
        context.strokePath()
    }
    
    private func drawGraph() {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        let width = frame.width
        let height = frame.height / 2
        
        let xOffset = width / CGFloat(data.count)
        var yOffset: CGFloat = 0
        var maxValue: CGFloat = 0.1 {
            didSet {
                yOffset = height / (maxValue + maxValue * 0.2)
            }
        }
        
        let axisXpath = CGMutablePath()
        let axisYpath = CGMutablePath()
        let axisZpath = CGMutablePath()
        
        axisXpath.move(to: CGPoint(x: 0, y: height))
        axisYpath.move(to: CGPoint(x: 0, y: height))
        axisZpath.move(to: CGPoint(x: 0, y: height))
        
        for (index, axisData) in data.enumerated() {
            configureLabel(with: axisData)
            maxValue = max(maxValue, abs(axisData.x), abs(axisData.y), abs(axisData.z))
            let x = CGFloat(index) * xOffset
            let axisXPosition = height - axisData.x * yOffset
            let axisYPosition = height - axisData.y * yOffset
            let axisZPosition = height - axisData.z * yOffset
            
            axisXpath.addLine(to: CGPoint(x: x, y: axisXPosition))
            axisYpath.addLine(to: CGPoint(x: x, y: axisYPosition))
            axisZpath.addLine(to: CGPoint(x: x, y: axisZPosition))
        }
        
        context.setLineWidth(1)
        context.addPath(axisXpath)
        context.setStrokeColor(UIColor.red.cgColor)
        context.strokePath()
        
        context.addPath(axisYpath)
        context.setStrokeColor(UIColor.green.cgColor)
        context.strokePath()
        
        context.addPath(axisZpath)
        context.setStrokeColor(UIColor.blue.cgColor)
        context.strokePath()
    }
    
    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Layout
extension LineGraphView {
    private func configureView() {
        addSubview(stackView)
        stackView.addArrangedSubview(axisXLabel)
        stackView.addArrangedSubview(axisYLabel)
        stackView.addArrangedSubview(axisZLabel)
    }
    
    private func configureConstraints() {
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.1)
        ])
    }
}
