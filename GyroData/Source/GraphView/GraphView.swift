//
//  GraphView.swift
//  GyroData
//
//  Created by Aejong on 2023/01/30.
//

import UIKit

final class GraphView: UIView {
    private let valueXLabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.text = "x: 0"
        
        return label
    }()
    
    private let valueYLabel = {
        let label = UILabel()
        label.textColor = .systemGreen
        label.text = "y: 0"
        
        return label
    }()
    
    private let valueZLabel = {
        let label = UILabel()
        label.textColor = .systemBlue
        label.text = "z: 0"
        
        return label
    }()
    
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
            yAxisOffset = maxValue + (maxValue * 0.2)
        }
    }
    private var scale: Double = 0
    
    private var viewModel: GraphViewModel
    
    init(viewModel: GraphViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        configureSubview()
        bind()
    }
    
    private func bind() {
        viewModel.bindGraphData { [weak self] motionCoordinate in
            self?.drawGraph(motionCoordinate)
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
        backgroundColor = .systemBackground
        self.layer.borderWidth = 2
        self.addSubview(valueXLabel)
        self.addSubview(valueYLabel)
        self.addSubview(valueZLabel)
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
}
