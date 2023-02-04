//
//  GraphView.swift
//  GyroData
//
//  Created by Mangdi on 2023/02/03.
//

import UIKit
import CoreMotion

class GraphView: UIView {

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

    private let xLayer = CAShapeLayer()
    private let yLayer = CAShapeLayer()
    private let zLayer = CAShapeLayer()
    private let xPath = UIBezierPath()
    private let yPath = UIBezierPath()
    private let zPath = UIBezierPath()
    private var currentX: CGFloat = 0

    var timeTrigger = true
    var timer = Timer()
    var transitionData: Transition = Transition(x: [], y: [], z: [])

    // MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)

        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        makeGridBackground()
        settingInitialization()
    }
}

// MARK: - Business Logic
extension GraphView {
    func replayGraphDrawing() {
        if timeTrigger {
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(replayDrawLine), userInfo: nil, repeats: true)
            timeTrigger = false
        }
    }

    private func findMinimumCount() -> Int {
        let xCount = transitionData.x.count
        let yCount = transitionData.y.count
        let zCount = transitionData.z.count
        var value = xCount

        if yCount < value { value = yCount }
        if zCount < value { value = zCount }
        return value
    }
}

// MARK: - LineDrawMethod
extension GraphView {
    func callDrawLine(_ data: CMLogItem, _ sensorType: SensorType) {
        switch sensorType {
        case .Accelerometer:
            guard let data = data as? CMAccelerometerData else { return }
            let xValue = data.acceleration.x
            let yValue = data.acceleration.y
            let zValue = data.acceleration.z
            drawLine(xValue, yValue, zValue)
        case .Gyro:
            guard let data = data as? CMGyroData else { return }
            let xValue = data.rotationRate.x
            let yValue = data.rotationRate.y
            let zValue = data.rotationRate.z
            drawLine(xValue, yValue, zValue)
        }
    }

    private func drawLine(_ xValue: CGFloat, _ yValue: CGFloat, _ zValue: CGFloat) {
        let xOffset: CGFloat = self.frame.width / CGFloat(600 - 1)
        let centerY = self.frame.height / 2
        currentX += xOffset
        let newXPosition = CGPoint(x: currentX, y: centerY - xValue)
        xPath.addLine(to: newXPosition)
        let newYPosition = CGPoint(x: currentX, y: centerY - yValue)
        yPath.addLine(to: newYPosition)
        let newZPosition = CGPoint(x: currentX, y: centerY - zValue)
        zPath.addLine(to: newZPosition)

        xPositionLabel.text = "x: \(xValue)"
        yPositionLabel.text = "y: \(yValue)"
        zPositionLabel.text = "z: \(zValue)"

        addGraphViewSublayer(layer: xLayer, path: xPath)
        addGraphViewSublayer(layer: yLayer, path: yPath)
        addGraphViewSublayer(layer: zLayer, path: zPath)
    }

    @objc private func replayDrawLine() {
        let xOffset: CGFloat = self.frame.width / CGFloat(600 - 1)
        let centerY = self.frame.height / 2
        let limitedIndex = findMinimumCount()
        var currentIndex = 0
        currentX += xOffset
        let newXPosition = CGPoint(x: currentX, y: centerY - transitionData.x[currentIndex])
        xPath.addLine(to: newXPosition)
        let newYPosition = CGPoint(x: currentX, y: centerY - transitionData.y[currentIndex])
        yPath.addLine(to: newYPosition)
        let newZPosition = CGPoint(x: currentX, y: centerY - transitionData.z[currentIndex])
        zPath.addLine(to: newZPosition)

        xPositionLabel.text = "x: \(transitionData.x[currentIndex])"
        yPositionLabel.text = "y: \(transitionData.y[currentIndex])"
        zPositionLabel.text = "z: \(transitionData.z[currentIndex])"

        addGraphViewSublayer(layer: xLayer, path: xPath)
        addGraphViewSublayer(layer: yLayer, path: yPath)
        addGraphViewSublayer(layer: zLayer, path: zPath)

        currentIndex += 1
        if currentIndex >= limitedIndex {
            timer.invalidate()
        }
    }

    private func addGraphViewSublayer(layer: CAShapeLayer, path: UIBezierPath) {
        switch layer {
        case xLayer:
            layer.strokeColor = UIColor.systemRed.cgColor
        case yLayer:
            layer.strokeColor = UIColor.systemGreen.cgColor
        case zLayer:
            layer.strokeColor = UIColor.systemBlue.cgColor
        default:
            return
        }
        layer.fillColor = nil
        layer.lineWidth = 2
        layer.path = path.cgPath
        self.layer.addSublayer(layer)
    }

    func settingInitialization() {
        [xLayer, yLayer, zLayer].forEach { $0.removeFromSuperlayer() }
        [xPath, yPath, zPath].forEach { $0.removeAllPoints() }
        currentX = 0
        settingStartLines()
    }

    private func settingStartLines() {
        let centerY = self.frame.height / 2
        xPath.move(to: CGPoint(x: currentX, y: centerY))
        yPath.move(to: CGPoint(x: currentX, y: centerY))
        zPath.move(to: CGPoint(x: currentX, y: centerY))
    }
}

// MARK: - GraphViewConfiguration
private extension GraphView {
    func makeGridBackground() {
        let gridLayer = CAShapeLayer()
        let gridPath = UIBezierPath()
        let divideCount = 8
        let xOffset = (self.frame.width - 20) / CGFloat(divideCount)
        let yOffset = (self.frame.height - 20) / CGFloat(divideCount)
        var currentX: CGFloat = 10
        var currentY: CGFloat = 10

        for index in 1...divideCount + 1 {
            gridPath.move(to: CGPoint(x: currentX, y: currentY))
            gridPath.addLine(to: CGPoint(x: self.frame.width - 10, y: currentY))
            currentY = 10 + CGFloat(index) * yOffset
        }

        currentY = 10

        for index in 1...divideCount + 1 {
            gridPath.move(to: CGPoint(x: currentX, y: currentY))
            gridPath.addLine(to: CGPoint(x: currentX, y: self.frame.height - 10))
            currentX = 10 + CGFloat(index) * xOffset
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
            xPositionLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            xPositionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),

            zPositionLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            zPositionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40),

            yPositionLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            yPositionLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        ])
    }
}
