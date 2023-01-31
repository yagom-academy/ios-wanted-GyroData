//
//  GraphView.swift
//  GyroData
//
//  Created by stone, LJ on 2023/01/31.
//

import UIKit
import CoreMotion

class GraphView: UIView {
    
    let xLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "x: 123"
        label.textAlignment = .center
        label.textColor = .red
        return label
    }()
    
    let yLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "y: 123"
        label.textAlignment = .center
        label.textColor = .blue
        return label
    }()
    
    let zLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "z: 123"
        label.textAlignment = .center
        label.textColor = .green
        return label
    }()
    
    let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        return stackView
    }()
    
    let xLayer = CAShapeLayer()
    let yLayer = CAShapeLayer()
    let zLayer = CAShapeLayer()
    
    let xPath = UIBezierPath()
    let yPath = UIBezierPath()
    let zPath = UIBezierPath()
    
    var currentXPoint: CGFloat = 0
    var currentYPoint: CGFloat = 0
    var currentZPoint: CGFloat = 0
    
    var offsetPoint: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        configureGridLayer()
    }
    
    func configureGridLayer() {
        let gridLayer = CAShapeLayer()
        let multiPath = CGMutablePath()
        let offset = frame.width / 8
        
        var index: CGFloat = offset
        
        for _ in 0..<7 {
            let xPath = UIBezierPath()
            let yPath = UIBezierPath()
            
            xPath.move(to: CGPoint(x: index, y: 0))
            yPath.move(to: CGPoint(x: 0, y: index))
            
            xPath.addLine(to: CGPoint(x: index, y: frame.height))
            yPath.addLine(to: CGPoint(x: frame.width, y: index))
            
            multiPath.addPath(xPath.cgPath)
            multiPath.addPath(yPath.cgPath)
            
            index += offset
        }
        
        gridLayer.strokeColor = UIColor.black.cgColor
        gridLayer.lineWidth = 0.2
        gridLayer.path = multiPath
        
        layer.addSublayer(gridLayer)
    }
    
    func configureLayout() {
        addSubview(labelStackView)
        labelStackView.addArrangedSubview(xLabel)
        labelStackView.addArrangedSubview(yLabel)
        labelStackView.addArrangedSubview(zLabel)
        
        NSLayoutConstraint.activate([
            labelStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            labelStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            labelStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    func configureLayer() {
        xLayer.lineWidth = 1
        xLayer.strokeColor = UIColor.red.cgColor
        xLayer.path = xPath.cgPath
        
        yLayer.lineWidth = 1
        yLayer.strokeColor = UIColor.green.cgColor
        yLayer.path = yPath.cgPath
        
        zLayer.lineWidth = 1
        zLayer.strokeColor = UIColor.blue.cgColor
        zLayer.path = zPath.cgPath
        
        layer.addSublayer(xLayer)
        layer.addSublayer(yLayer)
        layer.addSublayer(zLayer)
    }
    
    func drawLine(x: Double, y: Double, z: Double) {
        let startYPoint = frame.height / 2
        updateCoordinateLabel(x: x, y: y, z: z)
        
        xPath.move(to: CGPoint(x: offsetPoint, y: startYPoint + currentXPoint))
        yPath.move(to: CGPoint(x: offsetPoint, y: startYPoint + currentYPoint))
        zPath.move(to: CGPoint(x: offsetPoint, y: startYPoint + currentZPoint))
        
        offsetPoint += frame.width / 600
        
        currentXPoint = x
        currentYPoint = y
        currentZPoint = z
        
        xPath.addLine(to: CGPoint(x: offsetPoint, y: startYPoint + currentXPoint))
        yPath.addLine(to: CGPoint(x: offsetPoint, y: startYPoint + currentYPoint))
        zPath.addLine(to: CGPoint(x: offsetPoint, y: startYPoint + currentZPoint))
        
        xLayer.path = xPath.cgPath
        yLayer.path = yPath.cgPath
        zLayer.path = zPath.cgPath
    }
    
    func reset() {
        xLayer.path = nil
        yLayer.path = nil
        zLayer.path = nil
        xLayer.removeFromSuperlayer()
        yLayer.removeFromSuperlayer()
        zLayer.removeFromSuperlayer()
    }
    
    func configureData() {
        reset()
        configureLayer()
        currentXPoint = 0
        currentYPoint = 0
        currentZPoint = 0
        offsetPoint = 0
        xPath.removeAllPoints()
        yPath.removeAllPoints()
        zPath.removeAllPoints()
    }
    
    func updateCoordinateLabel(x: Double, y: Double, z: Double) {
        xLabel.text = "x: \(x)"
        yLabel.text = "y: \(y)"
        zLabel.text = "z: \(z)"
    }
}
