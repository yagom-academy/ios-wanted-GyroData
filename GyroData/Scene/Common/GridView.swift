//
//  GridView.swift
//  GyroData
//
//  Created by 백곰, 바드 on 2022/12/27.
//

import UIKit

final class GridView: UIView {
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    // MARK: - Methods
    
    override func draw(_ rect: CGRect) {
        let constantHeight: CGFloat = rect.height / 8
        var columnHeight = constantHeight
        let lineColor = UIColor.gray
        lineColor.setStroke()
        
        for _ in 1...8 {
            let horizontalPath = UIBezierPath()
            horizontalPath.move(to: CGPoint(x: 0, y: columnHeight))
            horizontalPath.addLine(to: CGPoint(x: rect.width, y: columnHeight))
            horizontalPath.stroke()
            
            let verticalPath = UIBezierPath()
            verticalPath.move(to: CGPoint(x: columnHeight, y: 0))
            verticalPath.addLine(to: CGPoint(x: columnHeight, y: rect.height))
            verticalPath.stroke()
            
            columnHeight += constantHeight
        }
    }
    
    private func commonInit() {
        setupBackgroundColor(.clear)
    }
    
    private func setupBackgroundColor(_ color: UIColor?) {
        backgroundColor = color
    }
}
