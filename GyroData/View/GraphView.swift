//
//  GraphView.swift
//  GyroData
//
//  Created by stone, LJ on 2023/01/31.
//

import UIKit
import CoreMotion

final class GraphView: UIView {
    private var coordinates: [Coordinate] = []
    private var scale: Double = 0
    
    private let xLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .red
        return label
    }()
    
    private let yLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .blue
        return label
    }()
    
    private let zLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .green
        return label
    }()
    
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        return stackView
    }()
    
    private var xLayer: CAShapeLayer?
    private var yLayer: CAShapeLayer?
    private var zLayer: CAShapeLayer?
    
    private var xPath: UIBezierPath?
    private var yPath: UIBezierPath?
    private var zPath: UIBezierPath?
    
    private var currentXPoint: CGFloat = 0
    private var currentYPoint: CGFloat = 0
    private var currentZPoint: CGFloat = 0
    
    private var offsetPoint: CGFloat = 0
    
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
    
    private func configureGridLayer() {
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
    
    private func configureLayout() {
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
    
    private func configureLayer() {
        xLayer?.lineWidth = 1
        xLayer?.strokeColor = UIColor.red.cgColor
        xLayer?.path = xPath?.cgPath
        
        yLayer?.lineWidth = 1
        yLayer?.strokeColor = UIColor.green.cgColor
        yLayer?.path = yPath?.cgPath
        
        zLayer?.lineWidth = 1
        zLayer?.strokeColor = UIColor.blue.cgColor
        zLayer?.path = zPath?.cgPath
        
        layer.addSublayer(xLayer!)
        layer.addSublayer(yLayer!)
        layer.addSublayer(zLayer!)
    }
    
    func drawLine(x: Double, y: Double, z: Double) {
        let startYPoint = frame.height / 2
        
        coordinates.append(Coordinate(x: x, y: y, z: z))
        updateCoordinateLabel(x: x, y: y, z: z)
        
        xPath?.move(to: CGPoint(x: offsetPoint, y: startYPoint + currentXPoint))
        yPath?.move(to: CGPoint(x: offsetPoint, y: startYPoint + currentYPoint))
        zPath?.move(to: CGPoint(x: offsetPoint, y: startYPoint + currentZPoint))
        
        offsetPoint += frame.width / 600
        
        currentXPoint = x * scale
        currentYPoint = y * scale
        currentZPoint = z * scale
        
        if currentXPoint > startYPoint || currentYPoint > startYPoint || currentZPoint > startYPoint ||
            -currentXPoint > startYPoint || -currentYPoint > startYPoint || -currentZPoint > startYPoint {
            scale -= scale * 0.2
            drawAll()
        }
        
        xPath?.addLine(to: CGPoint(x: offsetPoint, y: startYPoint + currentXPoint))
        yPath?.addLine(to: CGPoint(x: offsetPoint, y: startYPoint + currentYPoint))
        zPath?.addLine(to: CGPoint(x: offsetPoint, y: startYPoint + currentZPoint))
        
        xLayer?.path = xPath?.cgPath
        yLayer?.path = yPath?.cgPath
        zLayer?.path = zPath?.cgPath
    }
    
    private func drawAll() {
        let hasCoordinates = coordinates
        reset()
        configureLayer()
        
        hasCoordinates.forEach { coordinate in
            drawLine(x: coordinate.x, y: coordinate.y, z: coordinate.z)
        }
    }
    
    private func reset() {
        xLayer?.removeFromSuperlayer()
        yLayer?.removeFromSuperlayer()
        zLayer?.removeFromSuperlayer()
        
        xLayer = CAShapeLayer()
        yLayer = CAShapeLayer()
        zLayer = CAShapeLayer()
        
        xPath = UIBezierPath()
        yPath = UIBezierPath()
        zPath = UIBezierPath()
        
        xLabel.text = "x: 0"
        yLabel.text = "y: 0"
        zLabel.text = "z: 0"
        
        coordinates = []
        currentXPoint = 0
        currentYPoint = 0
        currentZPoint = 0
        offsetPoint = 0
    }
    
    func configureData() {
        scale = 20
        reset()
        configureLayer()
    }
    
    private func updateCoordinateLabel(x: Double, y: Double, z: Double) {
        xLabel.text = "x: \(x.decimalPlace(3))"
        yLabel.text = "y: \(y.decimalPlace(3))"
        zLabel.text = "z: \(z.decimalPlace(3))"
    }
}
