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
        label.text = "x: -3362"
        
        return label
    }()
    
    private let valueYLabel = {
        let label = UILabel()
        label.textColor = .systemGreen
        label.text = "y: -143"
        
        return label
    }()
    
    private let valueZLabel = {
        let label = UILabel()
        label.textColor = .systemBlue
        label.text = "z: 2497"
        
        return label
    }()
    
    
    private var viewModel: GraphViewModel
    var motionMeasures: MotionMeasures?
    var duration: Double?
    var drawMode: PageType = .view
    
    
    init(viewModel: GraphViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        configureView()
        bind()
    }
    
    private func bind() {
        viewModel.bindGraphData { [weak self] motionMeasures, duration in
            self?.motionMeasures = motionMeasures
            self?.duration = duration
        }
    }
    
    override func setNeedsDisplay() {
        super.setNeedsDisplay()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        backgroundColor = .clear
        self.layer.borderWidth = 2
        self.addSubview(valueXLabel)
        self.addSubview(valueYLabel)
        self.addSubview(valueZLabel)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        switch drawMode {
        case .play:
            break
        case .view:
            guard let motionMeasures,
                  let duration  else { return }
            drawWholeGraph(motionMeasures, for: duration)
        }
        
    }
    
    private func drawWholeGraph(_ motionMeasures: MotionMeasures, for duration: Double) {
        let graphData: [[Double]] = [
            motionMeasures.axisX.map { $0 * 30 },
            motionMeasures.axisY.map { $0 * 30 },
            motionMeasures.axisZ.map { $0 * 30 }
        ]
        var axisColors: [UIColor] = [.red, .green, .blue]
        
        let xOffset: Double = self.frame.width / CGFloat(duration)
        let startPosition = CGPoint(x: .zero, y: self.frame.height / CGFloat(2))
        
        graphData.forEach({ eachAxis in
            let path = UIBezierPath()
            let axisColor = axisColors.removeFirst()
            
            path.move(to: startPosition)
            path.lineWidth = 1
            axisColor.setStroke()
            
            path.drawPath(xOffset: xOffset, axisData: eachAxis, yFrameHeight: self.frame.height)
            
            path.stroke()
        })
    }
}

extension UIBezierPath {
    func drawPath(xOffset: Double, axisData: [Double], yFrameHeight: Double) {
        var currentX: Double = 0
        
        axisData.forEach { yPoint in
            self.addLine(to: CGPoint(x: currentX, y: yFrameHeight / 2 - yPoint))
            currentX += xOffset
        }
    }
}
