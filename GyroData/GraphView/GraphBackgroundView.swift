//
//  GraphBackgroundView.swift
//  GyroData
//
//  Created by minsson on 2022/12/29.
//

import UIKit

final class GraphBackgroundView: UIView {
    private enum Configuration {
        static let lineColor = UIColor.black
        static let lineWidth: CGFloat = 1.0
        
        static let numberOfLines = 7
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        drawBackgroundView()
    }
}

private extension GraphBackgroundView {
    func drawBackgroundView() {
        let path = UIBezierPath()
        path.lineWidth = Configuration.lineWidth
        Configuration.lineColor.setStroke()

        let horizontalLineInterval = bounds.height / CGFloat(Configuration.numberOfLines)
        let verticalLineInterval = bounds.width / CGFloat(Configuration.numberOfLines)

        drawHorizontalLines(Configuration.numberOfLines, interval: horizontalLineInterval, with: path)
        drawVerticalLines(Configuration.numberOfLines, interval: verticalLineInterval, with: path)
        
        path.stroke()
    }
    
    func drawHorizontalLines(_ numberOfLines: Int, interval: CGFloat, with path: UIBezierPath) {
        var y: CGFloat = 0.0
        for _ in 0...numberOfLines {
            path.move(to: CGPoint(x: 0.0, y: y))
            path.addLine(to: CGPoint(x: bounds.width, y: y))
            y += interval
        }
    }
    
    func drawVerticalLines(_ numberOfLines: Int, interval: CGFloat, with path: UIBezierPath) {
        var x: CGFloat = 0.0
        for _ in 0...numberOfLines {
            path.move(to: CGPoint(x: x, y: 0.0))
            path.addLine(to: CGPoint(x: x, y: bounds.height))
            x += interval
        }
    }
}

