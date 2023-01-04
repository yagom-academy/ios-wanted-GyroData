//
//  GraphView.swift
//  GyroData
//
//  Created by minsson on 2022/12/27.
//

import UIKit

protocol GraphDrawable: AnyObject {
    var data: MeasuredData? { get }
    
    func retrieveData(data: MeasuredData)
    func startDraw()
    func stopDraw()
}

protocol TickReceivable {
    func receive(x: Double, y: Double, z: Double)
}

enum DrawMode {
    case image
    case play
}

final class GraphView: UIView, TickReceivable, GraphDrawable {
    private enum Configuration {
        static let lineWidth: CGFloat = 2
        static let centerY: CGFloat = 150.5
        static let graphSizeAdjustment: Double = 30
        static let maximumMeasureCount: CGFloat = 600
    }
    
    private let xLabel: UILabel = {
        let xLabel = UILabel()
        xLabel.text = "x:"
        xLabel.textColor = .red
        return xLabel
    }()
    
    private let yLabel: UILabel = {
        let yLabel = UILabel()
        yLabel.text = "y:"
        yLabel.textColor = .green
        return yLabel
    }()
    
    private let zLabel: UILabel = {
        let zLabel = UILabel()
        zLabel.text = "z:"
        zLabel.textColor = .blue
        return zLabel
    }()
    
    private let valueLabelStackView: UIStackView = {
       let valueLabelStackView = UIStackView()
        valueLabelStackView.translatesAutoresizingMaskIntoConstraints = false
        valueLabelStackView.axis = .horizontal

        valueLabelStackView.distribution = .equalSpacing
        return valueLabelStackView
    }()
    
    private var sensorValueIndex = 0
    var data: MeasuredData?
    var drawMode: DrawMode = .play
    
    private let zeroX: CGFloat = 0
    private lazy var zeroY: CGFloat = self.frame.height / CGFloat(2)
    private var xInterval: CGFloat = 0
    
    private let pathX = UIBezierPath()
    private let pathY = UIBezierPath()
    private let pathZ = UIBezierPath()
    
    private var sensorXPoint: Double = 0
    private var sensorYPoint: Double = 0
    private var sensorZPoint: Double = 0
    
    private var xSensorCurrentXPoint: CGFloat = 0
    private var ySensorCurrentXPoint: CGFloat = 0
    private var zSensorCurrentXPoint: CGFloat = 0
    
    init() {
        super.init(frame: .zero)
        
        addViews()
        setupLayout()
        
        setupRootView()
        setupPathStartPosition()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GraphView {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        switch drawMode {
        case .play:
            drawWithAnimation(x: xSensorCurrentXPoint, yPoint: sensorXPoint, path: pathX, with: .red)
            drawWithAnimation(x: ySensorCurrentXPoint, yPoint: sensorYPoint, path: pathY, with: .green)
            drawWithAnimation(x: zSensorCurrentXPoint, yPoint: sensorZPoint, path: pathZ, with: .blue)
            
            updateValueLabels(
                x: (sensorXPoint / Configuration.graphSizeAdjustment).axisDecimal(),
                y: (sensorYPoint / Configuration.graphSizeAdjustment).axisDecimal(),
                z: (sensorZPoint / Configuration.graphSizeAdjustment).axisDecimal()
            )
        case .image:
            guard let measuredData = self.data else {
                return
            }
            drawGraph(of: measuredData)
        }
    }

    func retrieveData(data: MeasuredData) {
        self.data = data
        
        xInterval = CGFloat(350) / CGFloat(data.measuredTime * 10)
    }
    
    func drawWithAnimation(x: Double, yPoint: Double, path: UIBezierPath, with color: UIColor) {
        path.addLine(to: CGPoint(x: x, y: Configuration.centerY - yPoint))
        color.setStroke()
        path.stroke()
        
        switch color {
        case .red:
            xSensorCurrentXPoint += xInterval
        case .green:
            ySensorCurrentXPoint += xInterval
        case .blue:
            zSensorCurrentXPoint += xInterval
        default:
            break
        }
    }
    
    func receive(x: Double, y: Double, z: Double) {
        sensorXPoint = x * Configuration.graphSizeAdjustment
        sensorYPoint = y * Configuration.graphSizeAdjustment
        sensorZPoint = z * Configuration.graphSizeAdjustment
        
        xSensorCurrentXPoint += self.frame.width / Configuration.maximumMeasureCount
        ySensorCurrentXPoint += self.frame.width / Configuration.maximumMeasureCount
        zSensorCurrentXPoint += self.frame.width / Configuration.maximumMeasureCount
        
        self.setNeedsDisplay()
    }
    
    func startDraw() {
        guard let sensorXValue = data?.sensorData.axisX[sensorValueIndex],
              let sensorYValue = data?.sensorData.axisY[sensorValueIndex],
              let sensorZValue = data?.sensorData.axisZ[sensorValueIndex] else {
            return
        }
        
        sensorXPoint = sensorXValue * Configuration.graphSizeAdjustment
        sensorYPoint = sensorYValue * Configuration.graphSizeAdjustment
        sensorZPoint = sensorZValue * Configuration.graphSizeAdjustment
        
        sensorValueIndex += 1

        self.setNeedsDisplay()
    }
    
    func stopDraw() {
        resetPathsForReplay()
    }
    
    func resetPathsForReplay() {
        pathX.removeAllPoints()
        pathY.removeAllPoints()
        pathZ.removeAllPoints()
        
        xSensorCurrentXPoint = 0
        ySensorCurrentXPoint = 0
        zSensorCurrentXPoint = 0
        
        sensorValueIndex = 0
        
        setupPathStartPosition()
    }
    
    func configureDrawMode(_ drawMode: DrawMode) {
        self.drawMode = drawMode
    }
}

private extension GraphView {
    func setupRootView() {
        self.backgroundColor = .clear
    }
    
    func setupPathStartPosition() {
        pathX.move(to: CGPoint(x: zeroX, y: Configuration.centerY))
        pathY.move(to: CGPoint(x: zeroX, y: Configuration.centerY))
        pathZ.move(to: CGPoint(x: zeroX, y: Configuration.centerY))
    }
    
    func drawGraph(of measuredData: MeasuredData) {
        let zeroX: CGFloat = 0
        let centerY: CGFloat = self.frame.height / CGFloat(2)
        let xInterval = self.frame.width / CGFloat(measuredData.measuredTime * 10)
        
        let sensorData: [[Double]] = [
            measuredData.sensorData.axisX.map({ $0 * Configuration.graphSizeAdjustment}),
            measuredData.sensorData.axisY.map({ $0 * Configuration.graphSizeAdjustment}),
            measuredData.sensorData.axisZ.map({ $0 * Configuration.graphSizeAdjustment})
        ]
        
        var lineColors: [UIColor] = [.red, .green, .blue]
        
        sensorData.forEach { eachAxisData in
            let path = UIBezierPath()
            let lineColor: UIColor = lineColors.removeFirst()
            
            path.move(to: CGPoint(x: zeroX, y: centerY))
            path.lineWidth = Configuration.lineWidth
            lineColor.setStroke()
            
            path.drawGraph(strideBy: xInterval, with: eachAxisData, axisY: centerY)
            
            path.stroke()
        }
        
        guard let lastXValue = measuredData.sensorData.axisX.last,
              let lastYValue = measuredData.sensorData.axisY.last,
              let lastZValue = measuredData.sensorData.axisZ.last else {
            return
        }
        
        updateValueLabels(x: lastXValue.axisDecimal(), y: lastYValue.axisDecimal(), z: lastZValue.axisDecimal())
    }
    
    func addViews() {
        self.addSubview(valueLabelStackView)
        valueLabelStackView.addArrangedSubview(xLabel)
        valueLabelStackView.addArrangedSubview(yLabel)
        valueLabelStackView.addArrangedSubview(zLabel)
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            valueLabelStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            valueLabelStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            valueLabelStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8)
        ])
    }
    
    func updateValueLabels(x: Double, y: Double, z: Double) {
        xLabel.text = String("x: \(x)")
        yLabel.text = String("y: \(y)")
        zLabel.text = String("z: \(z)")
    }
}
