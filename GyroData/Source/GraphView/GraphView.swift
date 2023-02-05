//
//  GraphView.swift
//  GyroData
//
//  Created by Aejong on 2023/01/30.
//

import UIKit

final class GraphView: UIView {
    private var a = 1
    private let valueXLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.text = "x: 0"
        
        return label
    }()
    
    private let valueYLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGreen
        label.text = "y: 0"
        
        return label
    }()
    
    private let valueZLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemBlue
        label.text = "z: 0"
        
        return label
    }()
    
    private let valueStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 30
        return stackView
    }()
    
    private let graphBackgroundView = GraphBackgroundView()
    
    private let xPath = UIBezierPath()
    private let yPath = UIBezierPath()
    private let zPath = UIBezierPath()
    
    private var currentX: CGFloat = 0
    private var currentY: CGFloat = 0
    private var currentZ: CGFloat = 0
    
    private var xAxisOffset: CGFloat = 0
    private var yAxisOffset: CGFloat = 0
    private var maxValue: CGFloat = 1.0 {
        didSet {
            yAxisOffset = (maxValue + (maxValue * 0.2))
        }
    }
    
    private var viewModel: GraphViewModel
    
    init(viewModel: GraphViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        configureSubview()
        configureLayout()
        bind()
    }
    
    private func bind() {
        viewModel.bindGraphCoordinate { [weak self] motionCoordinate in
            self?.drawGraph(motionCoordinate)
            self?.setValueLabel(motionCoordinate)
        }
        
        viewModel.bindResetHandler { [weak self] in
            self?.reset()
        }
        
        viewModel.bindGraphMotionMeasures { [weak self] motionMeasures in
            let motionData = motionMeasures
            var axisX = Array(motionData.axisX.reversed())
            var axisY = Array(motionData.axisY.reversed())
            var axisZ = Array(motionData.axisZ.reversed())
            
            for _ in 0..<motionData.axisX.count {
                guard let x = axisX.popLast(),
                      let y = axisY.popLast(),
                      let z = axisZ.popLast()
                else {
                    return
                }
                
                self?.drawGraph(MotionCoordinate(x: x, y: y, z: z))
            }
            
            self?.setNeedsDisplay()
        }
    }
    
    override func setNeedsDisplay() {
        super.setNeedsDisplay()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureSubview() {
        backgroundColor = .clear
        graphBackgroundView.backgroundColor = .clear
        layer.borderWidth = 2
    
        [valueXLabel, valueYLabel, valueZLabel].forEach {
            valueStackView.addArrangedSubview($0)
        }
        
        addSubview(graphBackgroundView)
        addSubview(valueStackView)
    }
   
    private func configureLayout() {
        [graphBackgroundView, valueStackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            valueStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            valueStackView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            
            graphBackgroundView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            graphBackgroundView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            graphBackgroundView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            graphBackgroundView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        UIColor.systemRed.set()
        xPath.stroke()
        UIColor.green.set()
        yPath.stroke()
        UIColor.blue.set()
        zPath.stroke()
    }
    
    private func drawGraph(_ coordinate: MotionCoordinate) {
        let initialYPoint = bounds.height / 2
        xPath.lineWidth = 2
        yPath.lineWidth = 2
        zPath.lineWidth = 2
        
        xPath.move(to: CGPoint(x: xAxisOffset, y: initialYPoint + currentX))
        yPath.move(to: CGPoint(x: xAxisOffset, y: initialYPoint + currentX))
        zPath.move(to: CGPoint(x: xAxisOffset, y: initialYPoint + currentX))
        
        xAxisOffset += bounds.width / 600
        
        maxValue = max(abs(coordinate.x), abs(coordinate.y), abs(coordinate.z), maxValue)
        
        currentX = coordinate.x * yAxisOffset
        currentY = coordinate.y * yAxisOffset
        currentZ = coordinate.z * yAxisOffset
        
        xPath.addLine(to: CGPoint(x: xAxisOffset, y: initialYPoint + currentX))
        yPath.addLine(to: CGPoint(x: xAxisOffset, y: initialYPoint + currentY))
        zPath.addLine(to: CGPoint(x: xAxisOffset, y: initialYPoint + currentZ))
    }
    
    private func reset() {
        [xPath, yPath, zPath].forEach {
            $0.removeAllPoints()
        }
        
        maxValue = 1.0
        xAxisOffset = 0
        currentX = 0
        currentY = 0
        currentZ = 0
    }
    
    private func setValueLabel(_ coordinate: MotionCoordinate) {
        valueXLabel.text = "x: " + String(format: "%.1f", coordinate.x)
        valueYLabel.text = "y: " + String(format: "%.1f", coordinate.y)
        valueZLabel.text = "z: " + String(format: "%.1f", coordinate.z)
    }
}
