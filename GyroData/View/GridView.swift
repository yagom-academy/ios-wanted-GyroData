//
//  GridView.swift
//  GyroData
//
//  Created by ash and som on 2023/02/02.
//

import UIKit

class GridView: UIView {
    override func draw(_ rect: CGRect) {
        configureGridLine()
    }
    
    private func configureGridLine() {
        let gridLayer = CAShapeLayer()
        let multiPath = CGMutablePath()
        let offset = frame.width / 8
        var index: CGFloat = offset
        
        for _ in 0..<7 {
            let xPath = UIBezierPath()
            let yPath = UIBezierPath()
            
            xPath.move(to: CGPoint(x: index, y: 0))
            yPath.move(to: CGPoint(x: 0, y: index))
            
            xPath.addLine(to: CGPoint(x: index, y: frame.height))
            yPath.addLine(to: CGPoint(x: frame.width, y: index))
            
            multiPath.addPath(xPath.cgPath)
            multiPath.addPath(yPath.cgPath)
            
            index += offset
        }
        
        gridLayer.strokeColor = UIColor.white.cgColor
        gridLayer.lineWidth = 0.2
        gridLayer.path = multiPath
        
        layer.addSublayer(gridLayer)
    }
}
