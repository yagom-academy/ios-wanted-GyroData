//
//  GraphView.swift
//  GyroData
//
//  Created by Baem, Dragon on 2023/02/01.
//

import UIKit

class GraphView: UIView {
    var motionDatas: MotionDataModel? {
        didSet {
            guard let motionDatas = motionDatas else { return }
            
            dataListX.append(motionDatas.x)
            dataListY.append(motionDatas.y)
            dataListZ.append(motionDatas.z)
            
            setNeedsDisplay()
        }
    }
    
    private var dataListX = [Double]()
    private var dataListY = [Double]()
    private var dataListZ = [Double]()
    
    override func draw(_ rect: CGRect) {
        let xPath = UIBezierPath()
        
        xPath.lineWidth = 1
        xPath.move(to: CGPoint(x: rect.origin.x, y: rect.midY))
        xPath.addLine(to: CGPoint(x: rect.origin.x + rect.width, y: rect.midY))
        UIColor.systemGray.setStroke()
        xPath.stroke()

        drawLines(rect, color: .red, dataList: dataListX)
        drawLines(rect, color: .blue, dataList: dataListY)
        drawLines(rect, color: .green, dataList: dataListZ)
    }
    
    private func drawLines(_ rect: CGRect, color: UIColor, dataList: [Double]) {
        let ratioDataList = dataList.map { value in
            rect.midY - CGFloat(value) * 10
        }
        var xPosition: CGFloat = 0
        let xInterval = rect.width / 600
        let linePath = UIBezierPath()
        
        color.setStroke()
        linePath.lineWidth = 1
        ratioDataList.forEach({ value in
            let point = CGPoint(x: xPosition, y: value)
            
            if linePath.isEmpty {
                linePath.move(to: point)
            } else {
                linePath.addLine(to: point)
            }
            
            xPosition += xInterval
        })
        linePath.stroke()
    }
}
