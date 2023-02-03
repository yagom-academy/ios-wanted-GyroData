//
//  LineGraphView.swift
//  GyroData
//
//  Created by Aejong on 2023/01/30.
//

import UIKit

class LineGraphView: UIView {
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
    
    var values: [CGFloat] = []
    var xvalues: [CGFloat] = [10, 20, 40, 0, 30, 10, 20, 30]
    var yvalues: [CGFloat] = [50, 70, 10, 60, 90, 50, 10, 10]
    
    init(frame: CGRect, values: [CGFloat]) {
        super.init(frame: frame)
        self.values = values
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        self.layer.borderWidth = 2
        self.addSubview(valueXLabel)
        self.addSubview(valueYLabel)
        self.addSubview(valueZLabel)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        drawPath(values, UIColor.systemRed.cgColor)
        drawPath(xvalues, UIColor.cyan.cgColor)
        drawPath(yvalues, UIColor.systemBlue.cgColor)
    }
    
    private func drawPath(_ values: [CGFloat], _ strokeColor: CGColor) {
        let graphLayer = CAShapeLayer() // 1
        let graphPath = UIBezierPath() // 2
        
        let xOffset: CGFloat = self.frame.width / CGFloat(values.count)
        var currentX: CGFloat = 0
        let startPosition = CGPoint(x: currentX, y: self.frame.height / 2)
        graphPath.move(to: startPosition)
        
        for i in 0..<values.count {
            currentX += xOffset
            let newPosition = CGPoint(x: currentX, y: self.frame.height / 2 - values[i])
            
            graphPath.addLine(to: newPosition)
        }
        
        graphLayer.fillColor = nil
        graphLayer.strokeColor = strokeColor
        graphLayer.lineWidth = 2
        
        let newPath = graphPath.cgPath
        
        graphLayer.path = newPath // 4
        self.layer.addSublayer(graphLayer) // 5
    }
}
