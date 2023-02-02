//
//  GraphView.swift
//  GyroData
//
//  Created by Aaron, Gundy on 2023/02/02.
//

import UIKit

class GraphView: UIView {
    
    var dataSource: GraphViewDataSource?
    
    override func draw(_ rect: CGRect) {
        UIColor.systemGray.setStroke()
        let xAxisPath = UIBezierPath()
        xAxisPath.lineWidth = 1
        xAxisPath.move(to: CGPoint(x: rect.origin.x, y: rect.midY))
        xAxisPath.addLine(to: CGPoint(x: rect.origin.x + rect.width, y: rect.midY))
        xAxisPath.stroke()
        
        guard let numberOfLines = dataSource?.numberOfLines(graphView: self),
              let colorOfLines = dataSource?.colorOfLines(graphView: self),
              let dataList = dataSource?.dataList(graphView: self),
              let maximumXValueCount = dataSource?.maximumXValueCount(graphView: self) else {
            return
        }
        
        for index in 0..<numberOfLines {
            drawLines(rect,
                      color: colorOfLines[index],
                      dataList: dataList[index],
                      maximumXValueCount: maximumXValueCount)
        }
    }
    
    private func drawLines(_ rect: CGRect,
                           color: UIColor,
                           dataList: [Double],
                           maximumXValueCount: CGFloat) {
        
        var xValue: CGFloat = 0
        let yValueList = dataList.map { yValue in
            rect.midY - CGFloat(yValue) * 10
        }
        let spacing = rect.width / maximumXValueCount
        let linePath = UIBezierPath()
        color.setStroke()
        linePath.lineWidth = 1
        yValueList.forEach { yValue in
            let point = CGPoint(x: xValue, y: yValue)
            if linePath.isEmpty {
                linePath.move(to: point)
            } else {
                linePath.addLine(to: point)
            }
            xValue += spacing
        }
        linePath.stroke()
    }
}
