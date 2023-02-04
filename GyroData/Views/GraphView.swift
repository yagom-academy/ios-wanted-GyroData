//
//  GraphView.swift
//  GyroData
//
//  Created by 로빈 on 2023/01/30.
//

import UIKit

final class GraphView: UIView {

    private let viewModel: GraphViewModel
    private let axisXLabel = UILabel(text: "x: 0", textColor: .red, textAlignment: .center)
    private let axisYLabel = UILabel(text: "y: 0", textColor: .green, textAlignment: .center)
    private let axisZLabel = UILabel(text: "z: 0", textColor: .blue, textAlignment: .center)
    private let stackView = UIStackView(distribution: .fillEqually)
    
    init(viewModel: GraphViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        backgroundColor = .white
        configureView()
        configureConstraints()
        bindingViewModel()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        drawGrid(column: 8, row: 8)
        drawGraph()
    }

    private func bindingViewModel() {
        viewModel.bindingUpdate { [weak self] in
            self?.setNeedsDisplay()
        }
    }
    
    private func configureLabel(with data: AxisValue) {
        axisXLabel.text = String(Int(data.x * 1000))
        axisYLabel.text = String(Int(data.y * 1000))
        axisZLabel.text = String(Int(data.z * 1000))
    }
    
    private func drawGrid(column: Int, row: Int) {
        let linePath = UIBezierPath()
        linePath.lineWidth = 0.5
        UIColor.lightGray.setStroke()

        for i in 0...column {
            let y = frame.width / CGFloat(column) * CGFloat(i)
            linePath.move(to: CGPoint(x: 0, y: y))
            linePath.addLine(to: CGPoint(x: frame.width, y: y))
        }

        for i in 0...row {
            let x = frame.height / CGFloat(row) * CGFloat(i)
            linePath.move(to: CGPoint(x: x, y: 0))
            linePath.addLine(to: CGPoint(x: x, y: frame.height))
        }

        linePath.stroke()
    }
    
    private func drawGraph() {
        let width = frame.width
        let height = frame.height / 2
        
        let xOffset = width / CGFloat(viewModel.numberOfAxisValues)
        var yOffset: CGFloat = 0
        var maxValue: CGFloat = 0.1 {
            didSet {
                yOffset = height / (maxValue + maxValue * 0.2)
            }
        }
        
        let axisPathX = UIBezierPath()
        let axisPathY = UIBezierPath()
        let axisPathZ = UIBezierPath()
        
        axisPathX.move(to: CGPoint(x: 0, y: height))
        axisPathY.move(to: CGPoint(x: 0, y: height))
        axisPathZ.move(to: CGPoint(x: 0, y: height))
        
        for (index, axisData) in viewModel.axisValues.enumerated() {
            configureLabel(with: axisData)
            maxValue = max(maxValue, abs(axisData.x), abs(axisData.y), abs(axisData.z))
            let x = CGFloat(index) * xOffset
            let axisXPosition = height - axisData.x * yOffset
            let axisYPosition = height - axisData.y * yOffset
            let axisZPosition = height - axisData.z * yOffset
            
            axisPathX.addLine(to: CGPoint(x: x, y: axisXPosition))
            axisPathY.addLine(to: CGPoint(x: x, y: axisYPosition))
            axisPathZ.addLine(to: CGPoint(x: x, y: axisZPosition))
        }
        
        UIColor.red.setStroke()
        axisPathX.stroke()

        UIColor.green.setStroke()
        axisPathY.stroke()

        UIColor.blue.setStroke()
        axisPathZ.stroke()
    }
    
    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Layout
extension GraphView {
    private func configureView() {
        addSubview(stackView)
        stackView.addArrangedSubview(axisXLabel)
        stackView.addArrangedSubview(axisYLabel)
        stackView.addArrangedSubview(axisZLabel)
    }
    
    private func configureConstraints() {
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.1)
        ])
    }
}
