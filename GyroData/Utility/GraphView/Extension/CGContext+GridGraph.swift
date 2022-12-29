//
//  CGContext+GridGraph.swift
//  GyroData
//
//  Created by Judy on 2022/12/28.
//

import UIKit

extension CGContext {
    func drawGridGraph(in size: CGSize) {
        self.saveGState()
        
        let horizontalGridSpacing = size.height / 8.0
        let verticalGridSpacing = size.width / 8.0
        let baselineForY = size.height / 2.0
        
        translateBy(x: 0, y: baselineForY)
        
        for index in -3...3 {
            let position = horizontalGridSpacing * CGFloat(index)
            
            move(to: CGPoint(x: 0, y: position))
            addLine(to: CGPoint(x: size.width, y: position))
        }
        
        for index in 1...7 {
            let position = verticalGridSpacing * CGFloat(index)
            
            move(to: CGPoint(x: position, y: baselineForY))
            addLine(to: CGPoint(x: position, y: -1 * baselineForY))
        }

        setStrokeColor(UIColor.systemGray.cgColor)
        strokePath()
     
        self.restoreGState()
    }
}
