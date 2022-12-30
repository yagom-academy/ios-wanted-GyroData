//
//  GraphView.swift
//  GyroData
//
//  Created by Tak on 2022/12/30.
//

import UIKit
import CoreMotion

final class GraphView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("fatalError")
    }
    
    func configureGraph(item: GyroItem) {
        guard let x = item.x,
              let y = item.y,
              let z = item.z else { return }
        let graphX = createGraphLayer(values: x, color: .red)
        let graphY = createGraphLayer(values: y, color: .green)
        let graphZ = createGraphLayer(values: z, color: .blue)
        
        [graphX, graphY, graphZ].forEach {
            self.layer.addSublayer($0)
        }
    }
    
    private func createGraphLayer(values: [CGFloat], color: UIColor) -> CAShapeLayer {
        let layer = CAShapeLayer()
        let path = UIBezierPath()
        
        var currentX: CGFloat = 0
        
        let xOffset: CGFloat = self.frame.width / CGFloat(values.count)
        let centerY = self.frame.height / 2
        
        let centerYPosition = CGPoint(x: currentX, y: centerY)
        path.move(to: centerYPosition)
        
        for i in 0..<values.count {
            currentX += xOffset
            path.addLine(to: CGPoint(x: currentX, y: centerY - values[i]))
        }
        
        layer.fillColor = nil
        layer.strokeColor = color.cgColor
        layer.lineWidth = 2
        layer.path = path.cgPath
        
        return layer
    }
}
