//
//  GraphView.swift
//  GyroData
//
//  Created by 곽우종 on 2022/12/28.
//

import UIKit

final class GraphView: UIView {
    
    private enum Constant {
        static let dividCount: Int = 8
        static let lineColor: CGColor = UIColor.gray.cgColor
        static let lineWidth: CGFloat = 2
        static let baseLineWidth: CGFloat = 1
        static let graphBaseCount: CGFloat = 8
        static let multiplyer: CGFloat = 30
        static let graphViewBorderColor = UIColor.gray.cgColor
        static let borderWidth: CGFloat = 3
        static let space: CGFloat = 30
    }
    
    enum GraphType {
        case x, y, z
        
        var color: UIColor {
            switch self {
            case .x:
                return UIColor.red
            case .y:
                return UIColor.green
            case .z:
                return UIColor.blue
            }
        }
    }
    
    private var index = 0
    private var previousMotion: MotionValue = MotionValue(timestamp: TimeInterval(), x: 0, y: 0, z: 0)
    
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView(axis: .horizontal, alignment: .center, distribution: .fill, spacing: 20)
        stackView.backgroundColor = .clear
        stackView.addArrangedSubviews(xLabel, yLabel, zLabel)
        return stackView
    }()
    
    private lazy var xLabel: UILabel = {
        let label = UILabel()
        label.textColor = GraphType.x.color
        label.font = .preferredFont(for: .body, weight: .semibold)
        label.text = "x : 00"
        return label
    }()
    
    private lazy var yLabel: UILabel = {
        let label = UILabel()
        label.textColor = GraphType.y.color
        label.font = .preferredFont(for: .body, weight: .semibold)
        label.text = "y : 00"
        return label
    }()
    
    private lazy var zLabel: UILabel = {
        let label = UILabel()
        label.textColor = GraphType.z.color
        label.font = .preferredFont(for: .body, weight: .semibold)
        label.text = "z : 00"
        return label
    }()
    
    override func draw(_ rect: CGRect) {
        self.layer.addSublayer(drawBaseLayer())
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpLabel() {
        addSubviews(labelStackView)
        NSLayoutConstraint.activate([
            labelStackView.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            labelStackView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}

extension GraphView {
    
    func drawGraph(datas: [MotionValue]) {
        datas.forEach { data in
            drawGraph(data: data)
        }
    }
    
    func drawGraph(data: MotionValue?) {
        guard let data = data else {
            return
        }
        drawLines(data: data)
        index += 1
        previousMotion = data
    }
    
    func clean() {
        layer.sublayers = nil
        layer.addSublayer(drawBaseLayer())
        index = 0
    }
    
}

private extension GraphView {
    func drawBaseLayer() -> CAShapeLayer {
        setUpLabel()
        self.layer.borderWidth = Constant.borderWidth
        self.layer.borderColor = Constant.graphViewBorderColor
        let layer = CAShapeLayer()
        let path = UIBezierPath()
        
        let xOffset = self.frame.width / CGFloat(Constant.dividCount)
        let yOffset = self.frame.height / CGFloat(Constant.dividCount)
        var xpointer: CGFloat = 0
        var ypointer: CGFloat = 0
        let xMaxPointer: CGFloat = self.frame.width
        let yMaxPointer: CGFloat = self.frame.height
        
        var count = 1
        
        while (count < Constant.dividCount) {
            count += 1
            xpointer += xOffset
            path.move(to: CGPoint(x: xpointer, y: 0))
            let newXPosition = CGPoint(x: xpointer, y: yMaxPointer)
            path.addLine(to: newXPosition)
            
            ypointer += yOffset
            path.move(to: CGPoint(x: 0, y: ypointer))
            let newYPosition = CGPoint(x: xMaxPointer, y: ypointer)
            path.addLine(to: newYPosition)
        }
        
        layer.fillColor = Constant.lineColor
        layer.strokeColor = Constant.lineColor
        layer.lineWidth = Constant.baseLineWidth
        layer.path = path.cgPath
        return layer
    }
    
    func drawLines(data: MotionValue) {
        drawLine(type: .x, data: data.x)
        drawLine(type: .y, data: data.y)
        drawLine(type: .z, data: data.z)
    }
    
    func drawLine(type: GraphType, data: Double) {
        switch type {
        case .x: self.layer.addSublayer(createLineLayer(data: data, prevMotion: previousMotion.x, type: type))
        case .y: self.layer.addSublayer(createLineLayer(data: data, prevMotion: previousMotion.y, type: type))
        case .z: self.layer.addSublayer(createLineLayer(data: data, prevMotion: previousMotion.z, type: type))
        }
    }
    
    func createLineLayer(data: Double, prevMotion: Double, type: GraphType) -> CAShapeLayer {
        let offset = (self.frame.width - Constant.borderWidth * 2) / CGFloat(GraphConstant.timeout)
        let initHeight: CGFloat = self.frame.height / 2
        let pointer: CGFloat = Constant.borderWidth + offset * CGFloat(index)
        let layer = CAShapeLayer()
        let path = UIBezierPath()
        path.move(to: CGPoint(x: pointer, y: initHeight + prevMotion * Constant.multiplyer))
        let newPosition = CGPoint(x: pointer, y: initHeight + (data) * Constant.multiplyer)
        path.addLine(to: newPosition)
        layer.fillColor = type.color.cgColor
        layer.strokeColor = type.color.cgColor
        layer.lineWidth = Constant.lineWidth
        layer.path = path.cgPath
        return layer
    }
    
}
