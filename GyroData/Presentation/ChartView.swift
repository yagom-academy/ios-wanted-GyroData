//
//  ChartView.swift
//  GyroData
//
//  Created by bonf, seohyeon2 on 2022/12/28.
//

import UIKit

final class ChartView: UIView {
    
    enum Key: String {
        case xAnimationName = "AnimaitonX"
        case yAnimationName = "AnimaitonY"
        case zAnimationName = "AnimaitonZ"
    }
    
    private let xLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "X = 0"
        label.textColor = .red
        return label
    }()
    
    private let yLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Y = 0"
        label.textColor = .green
        return label
    }()
    
    private let zLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Z = 0"
        label.textColor = .blue
        return label
    }()
    
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        return stackView
    }()
    
    let layerX = CAShapeLayer()
    let layerY = CAShapeLayer()
    let layerZ = CAShapeLayer()
    
    let pathX = UIBezierPath()
    let pathY = UIBezierPath()
    let pathZ = UIBezierPath()
    
    private var lastValueOfX: Double = 0
    private var lastValueOfY: Double = 0
    private var lastValueOfZ: Double = 0
    
    private var current: Double = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawGrid()
    }
    
    private func setupLayout() {
        self.layer.borderWidth = 2
        
        self.addSubview(labelStackView)
        
        self.labelStackView.addArrangedSubview(xLabel)
        self.labelStackView.addArrangedSubview(yLabel)
        self.labelStackView.addArrangedSubview(zLabel)
        
        NSLayoutConstraint.activate([
            labelStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant:  10),
            labelStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            labelStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
        ])
    }
    
    private func drawGrid() {
        let layer = CAShapeLayer()
        let paths = CGMutablePath()
        
        var current: CGFloat = 0
        let Offset = frame.width / 10
        
        for _ in 0..<10 {
            let pathX = UIBezierPath()
            let pathY = UIBezierPath()
            
            current += Offset
            pathX.move(to: CGPoint(x: current, y: 0))
            pathY.move(to: CGPoint(x: 0, y: current))
            let newPositionX: CGPoint = CGPoint(x: current, y: frame.height)
            let newPositionY: CGPoint = CGPoint(x: frame.width, y: current)
            pathX.addLine(to: newPositionX)
            pathY.addLine(to: newPositionY)
            paths.addPath(pathX.cgPath)
            paths.addPath(pathY.cgPath)
        }
        
        layer.fillColor = nil
        layer.lineWidth = 0.5
        layer.path = paths
        layer.strokeColor = UIColor.darkGray.cgColor
        self.layer.addSublayer(layer)
    }
    
    func playChart(value: Motion) {
        let xOffset = frame.width / CGFloat(600)
        
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        var currentZ: CGFloat = 0
        
        pathX.move(to: CGPoint(x: currentX, y: CGFloat(value.motionX[0])))
        pathY.move(to: CGPoint(x: currentY, y: CGFloat(value.motionY[0])))
        pathZ.move(to: CGPoint(x: currentZ, y: CGFloat(value.motionZ[0])))
        
        for v in 0..<value.motionX.count {
            currentX += xOffset
            currentY += xOffset
            currentZ += xOffset
            let newPosition1: CGPoint = CGPoint(x: currentX, y: CGFloat(value.motionX[v]))
            let newPosition2: CGPoint = CGPoint(x: currentY, y: CGFloat(value.motionY[v]))
            let newPosition3: CGPoint = CGPoint(x: currentZ, y: CGFloat(value.motionZ[v]))
            pathX.addLine(to: newPosition1)
            pathY.addLine(to: newPosition2)
            pathZ.addLine(to: newPosition3)
        }
        
        setupLayers()
        
        self.layer.addSublayer(layerX)
        self.layer.addSublayer(layerY)
        self.layer.addSublayer(layerZ)
        
        layerX.removeAnimation(forKey: Key.xAnimationName.rawValue)
        layerY.removeAnimation(forKey: Key.yAnimationName.rawValue)
        layerZ.removeAnimation(forKey: Key.zAnimationName.rawValue)
        // 애니메이션 필요 없는 경우 return
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 60
        animation.fillMode = .forwards
        
        layerX.add(animation, forKey: Key.xAnimationName.rawValue)
        layerY.add(animation, forKey: Key.yAnimationName.rawValue)
        layerZ.add(animation, forKey: Key.zAnimationName.rawValue)
    }
    
    func drawChart(x: Double, y: Double, z: Double) {
        let xOffset = Double(frame.width / 600)
        let yOffset = frame.height / CGFloat(2)
        
        pathX.move(to: CGPoint(x: current, y: lastValueOfX))
        pathY.move(to: CGPoint(x: current, y: lastValueOfY))
        pathZ.move(to: CGPoint(x: current, y: lastValueOfZ))
        
        current += xOffset
        
        let mX = x * 30 + Double(yOffset)
        let mY = y * 30 + Double(yOffset)
        let mZ = z * 30 + Double(yOffset)
        
        pathX.addLine(to: CGPoint(x: current, y: mX))
        pathY.addLine(to: CGPoint(x: current, y: mY))
        pathZ.addLine(to: CGPoint(x: current, y: mZ))
        
        setupLayers()
        
        self.layer.addSublayer(layerX)
        self.layer.addSublayer(layerY)
        self.layer.addSublayer(layerZ)
        
        lastValueOfX = mX
        lastValueOfY = mY
        lastValueOfZ = mZ
    }
    
    func configureLabelText(x: String, y: String, z: String) {
        self.xLabel.text = "x = \(x)"
        self.yLabel.text = "y = \(y)"
        self.zLabel.text = "z = \(z)"
    }
    
    func setupDefaultValue() {
        self.xLabel.text = "x = 0"
        self.yLabel.text = "y = 0"
        self.zLabel.text = "z = 0"
        current = 0
        layerX.removeFromSuperlayer()
        layerY.removeFromSuperlayer()
        layerZ.removeFromSuperlayer()
        layerX.path = nil
        layerY.path = nil
        layerZ.path = nil
        pathX.removeAllPoints()
        pathY.removeAllPoints()
        pathZ.removeAllPoints()
    }
    
    private func setupLayers() {
        layerX.fillColor = nil
        layerX.lineWidth = 0.7
        layerX.path = pathX.cgPath
        layerX.strokeColor = UIColor.red.cgColor
        
        layerY.fillColor = nil
        layerY.lineWidth = 0.7
        layerY.path = pathY.cgPath
        layerY.strokeColor = UIColor.green.cgColor
        
        layerZ.fillColor = nil
        layerZ.lineWidth = 0.7
        layerZ.path = pathZ.cgPath
        layerZ.strokeColor = UIColor.blue.cgColor
    }
}
