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
        static let graphPointersCount: CGFloat = 600
        static let multiplyer: CGFloat = 30
        static let graphViewBorderColor = UIColor.gray.cgColor
        static let borderWidth: CGFloat = 3
        static let space: CGFloat = 30
    }
    
    private enum GraphType {
        case x,y,z
        
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
    
    private lazy var xLabel: UILabel = {
        let label = UILabel()
        label.textColor = GraphType.x.color
        label.font = .preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "x : 00"
        return label
    }()
    
    private lazy var yLabel: UILabel = {
        let label = UILabel()
        label.textColor = GraphType.y.color
        label.font = .preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "y : 00"
        return label
    }()
    
    private lazy var zLabel: UILabel = {
        let label = UILabel()
        label.textColor = GraphType.z.color
        label.font = .preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
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
        xLabel.text = "x : 00"
        yLabel.text = "y : 00"
        zLabel.text = "z : 00"
        addSubviews(xLabel, yLabel, zLabel)
        NSLayoutConstraint.activate([
            xLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constant.space),
            xLabel.topAnchor.constraint(equalTo: topAnchor),
            yLabel.topAnchor.constraint(equalTo: topAnchor),
            yLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            zLabel.topAnchor.constraint(equalTo: topAnchor),
            zLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constant.space)
        ])
    }
}

extension GraphView {
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
    
    func drawGraph(datas: [MotionValue]) {
        let layerX = CAShapeLayer()
        let layerY = CAShapeLayer()
        let layerZ = CAShapeLayer()
        let pathX = UIBezierPath()
        let pathY = UIBezierPath()
        let pathZ = UIBezierPath()
        
        let offset = (self.frame.width - Constant.borderWidth * 2) / Constant.graphPointersCount
        let initHeight: CGFloat = self.frame.height / 2
        
        var prevPositionX = CGPoint(x: Constant.borderWidth, y: initHeight)
        var prevPositionY = CGPoint(x: Constant.borderWidth, y: initHeight)
        var prevPositionZ = CGPoint(x: Constant.borderWidth, y: initHeight)
        
        for data in datas {
            pathX.move(to: prevPositionX)
            pathY.move(to: prevPositionY)
            pathZ.move(to: prevPositionZ)
            
            index += 1
            
            let newPositionX = CGPoint(x: prevPositionX.x + offset, y: initHeight + data.x * Constant.multiplyer)
            let newPositionY = CGPoint(x: prevPositionY.x + offset, y: initHeight + data.y * Constant.multiplyer)
            let newPositionZ = CGPoint(x: prevPositionZ.x + offset, y: initHeight + data.z * Constant.multiplyer)
            
            pathX.addLine(to: newPositionX)
            pathY.addLine(to: newPositionY)
            pathZ.addLine(to: newPositionZ)
            
            prevPositionX = newPositionX
            prevPositionY = newPositionY
            prevPositionZ = newPositionZ
        }
        
        layerX.fillColor = GraphType.x.color.cgColor
        layerY.fillColor = GraphType.y.color.cgColor
        layerZ.fillColor = GraphType.z.color.cgColor
        
        layerX.strokeColor = GraphType.x.color.cgColor
        layerY.strokeColor = GraphType.y.color.cgColor
        layerZ.strokeColor = GraphType.z.color.cgColor
        
        layerX.lineWidth = Constant.lineWidth
        layerY.lineWidth = Constant.lineWidth
        layerZ.lineWidth = Constant.lineWidth
        
        layerX.path = pathX.cgPath
        layerY.path = pathY.cgPath
        layerZ.path = pathZ.cgPath
        
        self.layer.addSublayer(layerX)
        self.layer.addSublayer(layerY)
        self.layer.addSublayer(layerZ)
    }
    
    func drawGraph(data: MotionValue?) {
        
        guard let data = data else {
            return
        }
        let layerX = CAShapeLayer()
        let layerY = CAShapeLayer()
        let layerZ = CAShapeLayer()
        let pathX = UIBezierPath()
        let pathY = UIBezierPath()
        let pathZ = UIBezierPath()
        
        let offset = (self.frame.width - Constant.borderWidth * 2) / Constant.graphPointersCount
        let initHeight: CGFloat = self.frame.height / 2
        var pointer: CGFloat = Constant.borderWidth + offset * CGFloat(index)
        
        xLabel.text = "x : " + String(format: "%02d", Int(data.x * Constant.multiplyer))
        yLabel.text = "y : " + String(format: "%02d", Int(data.y * Constant.multiplyer))
        zLabel.text = "z : " + String(format: "%02d", Int(data.z * Constant.multiplyer))
        
        pathX.move(to: CGPoint(x: pointer, y: initHeight + previousMotion.x * Constant.multiplyer))
        pathY.move(to: CGPoint(x: pointer, y: initHeight + previousMotion.y * Constant.multiplyer))
        pathZ.move(to: CGPoint(x: pointer, y: initHeight + previousMotion.z * Constant.multiplyer))
        
        index += 1
        previousMotion = data
        pointer = Constant.borderWidth + offset * CGFloat(index)
        
        let newPositionX = CGPoint(x: pointer, y: initHeight + (data.x) * Constant.multiplyer)
        let newPositionY = CGPoint(x: pointer, y: initHeight + (data.y) * Constant.multiplyer)
        let newPositionZ = CGPoint(x: pointer, y: initHeight + (data.z) * Constant.multiplyer)
        
        pathX.addLine(to: newPositionX)
        pathY.addLine(to: newPositionY)
        pathZ.addLine(to: newPositionZ)
        
        layerX.fillColor = GraphType.x.color.cgColor
        layerY.fillColor = GraphType.y.color.cgColor
        layerZ.fillColor = GraphType.z.color.cgColor
        
        layerX.strokeColor = GraphType.x.color.cgColor
        layerY.strokeColor = GraphType.y.color.cgColor
        layerZ.strokeColor = GraphType.z.color.cgColor
        
        layerX.lineWidth = Constant.lineWidth
        layerY.lineWidth = Constant.lineWidth
        layerZ.lineWidth = Constant.lineWidth
        
        layerX.path = pathX.cgPath
        layerY.path = pathY.cgPath
        layerZ.path = pathZ.cgPath
        
        self.layer.addSublayer(layerX)
        self.layer.addSublayer(layerY)
        self.layer.addSublayer(layerZ)
    }
    
    func clean() {
        layer.sublayers = nil
        layer.addSublayer(drawBaseLayer())
        index = 0
    }
}
