//
//  GraphView.swift
//  GyroData
//
//  Created by 천수현 on 2022/12/27.
//

import UIKit

final class GraphView: UIView {
    private let redLabel: UILabel = {
        let label = UILabel()
        label.text = "x:0"
        label.textColor = UIColor.red
        return label
    }()

    private let blueLabel: UILabel = {
        let label = UILabel()
        label.text = "z:0"
        label.textColor = UIColor.blue
        return label
    }()

    private let greenLabel: UILabel = {
        let label = UILabel()
        label.text = "y:0"
        label.textColor = UIColor.green
        return label
    }()

    private var viewModel = GraphViewModel()

    private var widthFor1Hz: CGFloat {
        return self.frame.width / viewModel.xScale
    }

    private var heightFor1Hz: CGFloat {
        return self.frame.height / viewModel.yScale
    }

    private lazy var redLinesLayer = initializeLayer(color: UIColor.red.cgColor)
    private lazy var blueLinesLayer = initializeLayer(color: UIColor.blue.cgColor)
    private lazy var greenLinesLayer = initializeLayer(color: UIColor.green.cgColor)

    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }

    init(xScale: CGFloat) {
        super.init(frame: .zero)
        viewModel.xScale = xScale
        layout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        let backgroundLayer = initializeBackgroundLayer()
        layer.addSublayer(backgroundLayer)
        [redLinesLayer, blueLinesLayer, greenLinesLayer].forEach {
            self.layer.addSublayer($0)
        }
    }

    func drawGraphFor1Hz(layerType: Layer, value: Double) {
        var layer: CAShapeLayer?
        let scaledValue = value * 1000

        switch layerType {
        case .red:
            layer = redLinesLayer
            redLabel.text = String(format: "x:%.0f", scaledValue)
            viewModel.pastValueForRed.append(value)
        case .blue:
            layer = blueLinesLayer
            blueLabel.text = String(format: "z:%.0f", scaledValue)
            viewModel.pastValueForBlue.append(value)
        case .green:
            layer = greenLinesLayer
            greenLabel.text = String(format: "y:%.0f", scaledValue)
            viewModel.pastValueForGreen.append(value)
        }

        guard let path = layer?.path?.mutableCopy() else { return }
        let nextPoint = CGPoint(x: path.currentPoint.x + widthFor1Hz, y: bounds.midY - value * heightFor1Hz)

        let isExceedScale = abs(value) > viewModel.yScale / 2
        if isExceedScale {
            upScaleGraph(with: value)
        }

        path.addLine(to: nextPoint)
        layer?.path = path
    }

    func reset() {
        resetViewModel()
        eraseGraph()
    }

    private func resetViewModel() {
        viewModel.yScale = 60
        viewModel.pastValueForRed.removeAll()
        viewModel.pastValueForBlue.removeAll()
        viewModel.pastValueForGreen.removeAll()
    }

    private func eraseGraph() {
        redLabel.text = "x:0"
        blueLabel.text = "z:0"
        greenLabel.text = "y:0"
        [redLinesLayer, blueLinesLayer, greenLinesLayer].forEach {
            $0.removeFromSuperlayer()
        }
        redLinesLayer = initializeLayer(color: UIColor.red.cgColor)
        blueLinesLayer = initializeLayer(color: UIColor.blue.cgColor)
        greenLinesLayer = initializeLayer(color: UIColor.green.cgColor)

        [redLinesLayer, blueLinesLayer, greenLinesLayer].forEach {
            self.layer.addSublayer($0)
        }
    }

    private func upScaleGraph(with value: Double) {
        viewModel.yScale =  1.2 * 2 * abs(value)
        eraseGraph()
        drawPastValues()
    }

    private func drawPastValues() {
        let pastValueForRed = viewModel.pastValueForRed
        let pastValueForBlue = viewModel.pastValueForBlue
        let pastValueForGreen = viewModel.pastValueForGreen

        viewModel.pastValueForRed.removeAll()
        viewModel.pastValueForBlue.removeAll()
        viewModel.pastValueForGreen.removeAll()

        pastValueForRed.forEach {
            drawGraphFor1Hz(layerType: .red, value: $0)
        }

        pastValueForBlue.forEach {
            drawGraphFor1Hz(layerType: .blue, value: $0)
        }

        pastValueForGreen.forEach {
            drawGraphFor1Hz(layerType: .green, value: $0)
        }
    }

    private func layout() {
        let spacing = 10.0
        [redLabel, blueLabel, greenLabel].forEach {
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            redLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: spacing),
            greenLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            blueLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -spacing),
            redLabel.topAnchor.constraint(equalTo: topAnchor, constant: spacing),
            blueLabel.topAnchor.constraint(equalTo: topAnchor, constant: spacing),
            greenLabel.topAnchor.constraint(equalTo: topAnchor, constant: spacing)
        ])
    }
    
    private func initializeBackgroundLayer() -> CAShapeLayer {
        let drawPath: (CGPoint, CGPoint) -> CGPath = { start, end in
            let path = CGMutablePath()
            path.move(to: start)
            path.addLine(to: end)
            return path
        }
        let backgroud = CAShapeLayer()
        backgroud.lineWidth = 1
        backgroud.strokeColor = UIColor.gray.cgColor
        backgroud.fillColor = UIColor.clear.cgColor
        
        let path = CGMutablePath()
        let verticalSpace = frame.height / CGFloat(viewModel.verticalBackgroundSlice)
        let horizontalSpace = frame.width / CGFloat(viewModel.horizontalBackgroundSlice)
        
        var tempY: CGFloat = verticalSpace
        while tempY < frame.height {
            let startPoint = CGPoint(x: 0, y: tempY)
            let endPoint = CGPoint(x: frame.width, y: tempY)
            path.addPath(drawPath(startPoint, endPoint))
            tempY += verticalSpace
        }
        
        var tempX: CGFloat = horizontalSpace
        while tempX < frame.height {
            let startPoint = CGPoint(x: tempX, y: 0)
            let endPoint = CGPoint(x: tempX, y: frame.height)
            path.addPath(drawPath(startPoint, endPoint))
            tempX += horizontalSpace
        }
        
        backgroud.path = path
        return backgroud
    }

    private func initializeLayer(color: CGColor) -> CAShapeLayer {
        let layer = CAShapeLayer()
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: bounds.midY))
        layer.path = path

        layer.lineWidth = 2
        layer.strokeColor = color
        layer.fillColor = UIColor.clear.cgColor
        return layer
    }
}

extension GraphView {
    enum Layer {
        case red
        case blue
        case green
    }
}
