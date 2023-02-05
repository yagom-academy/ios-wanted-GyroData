//
//  GraphView.swift
//  GyroData
//
//  Created by junho on 2023/02/01.
//

import UIKit

final class GraphView: UIView {
    private let viewModel = GraphViewModel()
    private lazy var currentXPoint = CGPoint(x: .zero, y: frame.height / 2)
    private lazy var currentYPoint = CGPoint(x: .zero, y: frame.height / 2)
    private lazy var currentZPoint = CGPoint(x: .zero, y: frame.height / 2)
    private var xLayer = CAShapeLayer()
    private var yLayer = CAShapeLayer()
    private var zLayer = CAShapeLayer()
    private var gridLayer: CAShapeLayer?
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let xLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.font = .preferredFont(forTextStyle: .caption1)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private let yLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGreen
        label.font = .preferredFont(forTextStyle: .caption1)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private let zLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemBlue
        label.font = .preferredFont(forTextStyle: .caption1)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        resetGraph()
        configureStackView()
        setLabelsToZero()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func drawGrid() {
        layer.borderColor = UIColor.systemGray.cgColor
        layer.borderWidth = 1
        
        let width: Int = Int(bounds.width)
        let fraction: Int = Int(bounds.width) / 8
        let path = UIBezierPath()
        for i in 1..<8 {
            path.move(to: CGPoint(x: .zero, y: fraction * i))
            path.addLine(to: CGPoint(x: width, y: fraction * i))
            path.move(to: CGPoint(x: fraction * i, y: .zero))
            path.addLine(to: CGPoint(x: fraction * i, y: width))
        }
        
        let layer = createLineLayer(color: UIColor.systemGray.cgColor)
        layer.frame = bounds
        layer.path = path.cgPath
        layer.masksToBounds = true
        setNeedsDisplay()
    }
    
    func drawCompleteGraph(with coordinates: [Coordinate]) {
        viewModel.action(.drawCompleteGraph(with: coordinates))
    }
    
    func configureAxisRange(_ coordinates: [Coordinate]) {
        viewModel.action(.configureAxisRange(with: coordinates))
    }
    
    func updateGraph(with coordinate: Coordinate) {
        viewModel.action(.updateGraph(
            coordinate: coordinate,
            handler: { [weak self] coordinate in
                self?.drawLines(to: coordinate)
                self?.setNeedsDisplay()
            })
        )
    }
    
    func resetGraph() {
        removeGraphLines()
        setLabelsToZero()
        setNeedsDisplay()
    }
    
    private func bind() {
        viewModel.bind(drawGraphLines)
        viewModel.bind(updateLabels)
    }
    
    private func configureStackView() {
        addSubview(labelStackView)
        [xLabel, yLabel, zLabel].forEach { labelStackView.addArrangedSubview($0) }
        
        NSLayoutConstraint.activate([
            labelStackView.topAnchor.constraint(equalTo: topAnchor),
            labelStackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9),
            labelStackView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    private func createLineLayer(color: CGColor) -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.lineWidth = 1
        layer.strokeColor = color
        self.layer.addSublayer(layer)
        return layer
    }
    
    private func drawGraphLines(_ coordinates: [Coordinate]) {
        removeGraphLines()
        coordinates.forEach { coordinate in
            drawLines(to: coordinate)
        }
        setNeedsDisplay()
    }
    
    private func drawLines(to coordinate: Coordinate) {
        viewModel.count += 1
        let xPoint = CGPoint(x: Double(viewModel.count) / viewModel.maxCount * frame.width, y: calculate(coordinate.x))
        let yPoint = CGPoint(x: Double(viewModel.count) / viewModel.maxCount * frame.width, y: calculate(coordinate.y))
        let zPoint = CGPoint(x: Double(viewModel.count) / viewModel.maxCount * frame.width, y: calculate(coordinate.z))
        
        drawLine(by: xLayer, from: currentXPoint, to: xPoint)
        drawLine(by: yLayer, from: currentYPoint, to: yPoint)
        drawLine(by: zLayer, from: currentZPoint, to: zPoint)
        
        currentXPoint = xPoint
        currentYPoint = yPoint
        currentZPoint = zPoint
    }
    
    private func updateLabels(with values: (x: String, y: String, z: String)) {
        xLabel.text = "x: " + values.x
        yLabel.text = "y: " + values.y
        zLabel.text = "z: " + values.z
    }
    
    private func setLabelsToZero() {
        xLabel.text = "x: 0"
        yLabel.text = "y: 0"
        zLabel.text = "z: 0"
    }
    
    private func drawLine(by lineLayer: CAShapeLayer, from start: CGPoint?, to end: CGPoint) {
        guard let start else { return }
        let path: UIBezierPath
        if let cgPath = lineLayer.path {
            path = UIBezierPath(cgPath: cgPath)
        } else {
            path = UIBezierPath()
        }
        path.move(to: start)
        path.addLine(to: end)
        lineLayer.frame = bounds
        lineLayer.path = path.cgPath
    }
    
    private func removeGraphLines() {
        layer.sublayers?.removeAll(where: { layer in
            layer == xLayer || layer == yLayer || layer == zLayer
        })
        xLayer = createLineLayer(color: UIColor.systemRed.cgColor)
        yLayer = createLineLayer(color: UIColor.systemGreen.cgColor)
        zLayer = createLineLayer(color: UIColor.systemBlue.cgColor)
        
        viewModel.count = 1.0
        currentXPoint = CGPoint(x: .zero, y: frame.height / 2)
        currentYPoint = CGPoint(x: .zero, y: frame.height / 2)
        currentZPoint = CGPoint(x: .zero, y: frame.height / 2)
    }
    
    private func calculate(_ y: Double) -> CGFloat {
        let height = frame.height
        let centerY = height / 2
        let axisRange = viewModel.maxValue * 2 * 1.2
        let calculatedY = centerY + CGFloat(y) / axisRange * height
        return calculatedY
    }
}
