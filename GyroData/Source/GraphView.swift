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
        UIColor.systemGray.setStroke()
        let xAxisPath = UIBezierPath()
        xAxisPath.lineWidth = 1
        xAxisPath.move(to: CGPoint(x: rect.origin.x, y: rect.midY))
        xAxisPath.addLine(to: CGPoint(x: rect.origin.x + rect.width, y: rect.midY))
        xAxisPath.stroke()
        
        drawLines(rect, color: .red, dataList: dataListX)
        drawLines(rect, color: .blue, dataList: dataListY)
        drawLines(rect, color: .green, dataList: dataListZ)
    }
    
    private func drawLines(_ rect: CGRect, color: UIColor, dataList: [Double]) {
        
        let mappedDataList = dataList.map { value in
            rect.midY - CGFloat(value)
        }
        
        color.setStroke()
        var x: CGFloat = 0
        let space = rect.width / CGFloat(mappedDataList.count - 1)
        let linePath = UIBezierPath()
        linePath.lineWidth = 1
        mappedDataList.forEach({ value in
            let point = CGPoint(x: x, y: value)
            if linePath.isEmpty {
                linePath.move(to: point)
            } else {
                linePath.addLine(to: point)
            }
            x += space
        })
        linePath.stroke()
    }
}
