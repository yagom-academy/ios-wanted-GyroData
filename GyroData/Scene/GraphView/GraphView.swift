//
//  GraphView.swift
//  GyroData
//
//  Created by Wonbi on 2023/02/05.
//

import UIKit

final class GraphView: UIView {
    private var gridHeight: CGFloat {
        return bounds.height / 8
    }
    
    private var gridWidth: CGFloat {
        return bounds.width / 8
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setStrokeColor(UIColor.systemGray4.cgColor)
        
        for lineIndex in 1...7 {
            // 세로줄
            context.move(to: CGPoint(x: gridWidth * CGFloat(lineIndex), y: 0))
            context.addLine(to: CGPoint(x: gridWidth * CGFloat(lineIndex), y: bounds.height))
            // 가로줄
            context.move(to: CGPoint(x: 0, y: gridHeight * CGFloat(lineIndex)))
            context.addLine(to: CGPoint(x: bounds.width, y: gridHeight * CGFloat(lineIndex)))
        }
        
        context.strokePath()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray4.cgColor
        backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
