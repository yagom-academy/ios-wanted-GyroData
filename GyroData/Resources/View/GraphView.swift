//
//  GraphView.swift
//  GyroData
//
//  Created by Mangdi on 2023/02/03.
//

import UIKit
import CoreMotion

final class GraphView: UIView {

    // MARK: - Constant
    enum Constant {
        static let middleSpacing: CGFloat = 20
        static let largeSpacing: CGFloat = 40
    }
    
    // MARK: - Property
    private let xPositionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.text = "x:"
        return label
    }()
    
    private let yPositionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGreen
        label.text = "y:"
        return label
    }()
    
    private let zPositionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemBlue
        label.text = "z:"
        return label
    }()
    
    private let xLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = UIColor.systemRed.cgColor
        layer.fillColor = nil
        layer.lineWidth = 1.5
        return layer
    }()
    
    private let yLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = UIColor.systemGreen.cgColor
        layer.fillColor = nil
        layer.lineWidth = 1.5
        return layer
    }()
    
    private let zLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = UIColor.systemBlue.cgColor
        layer.fillColor = nil
        layer.lineWidth = 1.5
        return layer
    }()
    
    private let xPath = UIBezierPath()
    private let yPath = UIBezierPath()
    private let zPath = UIBezierPath()
    private var currentX: CGFloat = 0
    
    private var isCheckStartLines = false
    private var timer: Timer?
    private var currentTime: Double = 0
    private var currentIndex: Int = 0
    private var transitionData: Transition = Transition(values: [])
    var delegate: GraphDelegate?
    
    var yOffset: CGFloat = 0
    
    var maxValue: CGFloat = 1.0 {
        didSet {
            yOffset = (frame.height / 2) / (maxValue + maxValue * 0.2)
        }
    }
    
    // MARK: - LifeCycle
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        makeGridBackground()
        settingInitialization()
        configureUI()
    }
}

// MARK: - Draw Logic
extension GraphView {
    func drawRecord(with sensor: SensorType, values: Tick, isStart: Bool = false) {
        let tickValues = values.convert(with: sensor)
        drawLine(values: tickValues, isStart: isStart)
    }
    
    func drawPlayGraph(
        ticks: [Tick],
        viewType: PlayViewController.viewType
    ) {
        var ticks = ticks
        let firstTick = ticks.removeFirst().convert()
        
        settingInitialization()
        setStartTick(tick: firstTick)
        
        switch viewType {
        case .play:
            transitionData = Transition(values: ticks)
            if timer == nil {
                timer = Timer.scheduledTimer(
                    timeInterval: 0.1,
                    target: self,
                    selector: #selector(replayDrawLine),
                    userInfo: nil,
                    repeats: true
                )
            }
        case .view:
            ticks.forEach { drawLine(values: $0.convert(), isStart: false) }
        }
    }
    
    @objc private func replayDrawLine() {
        let limitedIndex = findMinimumCount()
        currentTime += 0.1
        delegate?.checkTime(time: currentTime)
        
        guard currentIndex < limitedIndex else {
            timer?.invalidate()
            delegate?.isCheckFinish = true
            return
        }
        
        let tick = self.transitionData.values[currentIndex]
        drawRecord(with: .Accelerometer, values: tick, isStart: false)
        currentIndex += 1
    }
    
    private func drawLine(values: Tick, isStart: Bool) {
        let xOffset: CGFloat = self.frame.width / CGFloat(600)
        let centerY = self.frame.height / 2
        
        maxValue = max(abs(values.x), abs(values.y), abs(values.z), maxValue)
        
        let xPosition = centerY - values.x * yOffset
        let yPosition = centerY - values.y * yOffset
        let zPosition = centerY - values.z * yOffset
        
        if isStart {
            xPath.move(to: CGPoint(x: currentX, y: xPosition))
            yPath.move(to: CGPoint(x: currentX, y: yPosition))
            zPath.move(to: CGPoint(x: currentX, y: zPosition))
        } else {
            currentX += xOffset
            let newX = CGPoint(x: currentX, y: xPosition)
            let newY = CGPoint(x: currentX, y: yPosition)
            let newZ = CGPoint(x: currentX, y: zPosition)
            
            xPath.addLine(to: newX)
            yPath.addLine(to: newY)
            zPath.addLine(to: newZ)
        }
        
        xLayer.path = xPath.cgPath
        yLayer.path = yPath.cgPath
        zLayer.path = zPath.cgPath
        
        [xLayer, yLayer, zLayer].forEach {
            layer.addSublayer($0)
        }
        
        setLabels(tick: values)
    }
}

// MARK: - Business Logic
extension GraphView {
    private func setStartTick(tick: Tick) {
        let centerY = frame.height / 2
        xPath.move(to: CGPoint(x: .zero, y: centerY - tick.x))
        yPath.move(to: CGPoint(x: .zero, y: centerY - tick.y))
        zPath.move(to: CGPoint(x: .zero, y: centerY - tick.z))
    }
    
    private func findMinimumCount() -> Int {
        let xCount = transitionData.values.map { $0.x }.count
        let yCount = transitionData.values.map { $0.y }.count
        let zCount = transitionData.values.map { $0.z }.count
        return min(xCount, yCount, zCount)
    }
    
    private func setLabels(tick: Tick) {
        xPositionLabel.text = "x: \(Double(round(1000 * tick.x) / 1000))"
        yPositionLabel.text = "y: \(Double(round(1000 * tick.y) / 1000))"
        zPositionLabel.text = "z: \(Double(round(1000 * tick.z) / 1000))"
    }
    
    func settingInitialization() {
        [xLayer, yLayer, zLayer].forEach { $0.removeFromSuperlayer() }
        [xPath, yPath, zPath].forEach { $0.removeAllPoints() }
        currentX = 0
    }
    
    func resetGraph() {
        timer?.invalidate()
        timer = nil
        maxValue = 0.1
        currentTime = 0
        currentIndex = 0
    }
}

// MARK: - Graph Background Configuration
private extension GraphView {
    private func makeGridBackground() {
        let gridLayer = CAShapeLayer()
        let gridPath = UIBezierPath()
        let xOffset = self.frame.width / CGFloat(8)
        let yOffset = self.frame.height / CGFloat(8)
        var currentX: CGFloat = 0, currentY: CGFloat = 0
        
        for index in 0..<9 {
            gridPath.move(to: CGPoint(x: currentX, y: currentY))
            gridPath.addLine(to: CGPoint(x: self.frame.width, y: currentY))
            currentY = CGFloat(index + 1) * yOffset
        }
        
        currentY = 0
        
        for index in 0..<9 {
            gridPath.move(to: CGPoint(x: currentX, y: currentY))
            gridPath.addLine(to: CGPoint(x: currentX, y: self.frame.height))
            currentX = CGFloat(index + 1) * xOffset
        }
        
        gridLayer.fillColor = nil
        gridLayer.strokeColor = UIColor.systemGray.cgColor
        gridLayer.lineWidth = 2
        gridLayer.path = gridPath.cgPath
        self.layer.addSublayer(gridLayer)
    }
}

// MARK: - UIConfiguration
private extension GraphView {
    func configureUI() {
        addChildView()
        setUpLayouts()
    }
    
    func addChildView() {
        [xPositionLabel, yPositionLabel, zPositionLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
    }
    
    func setUpLayouts() {
        NSLayoutConstraint.activate([
            xPositionLabel.topAnchor.constraint(equalTo: topAnchor, constant: Constant.middleSpacing),
            xPositionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constant.largeSpacing),
            
            zPositionLabel.topAnchor.constraint(equalTo: topAnchor, constant: Constant.middleSpacing),
            zPositionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constant.largeSpacing),
            
            yPositionLabel.topAnchor.constraint(equalTo: topAnchor, constant: Constant.middleSpacing),
            yPositionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
}
