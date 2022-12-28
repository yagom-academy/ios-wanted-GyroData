//
//  GraphView.swift
//  GyroData
//
//  Created by 곽우종 on 2022/12/28.
//

import UIKit

final class GraphView: UIView {
    
    private var index = 0
    private var previousMotion: MotionValue = MotionValue(timestamp: TimeInterval(), x: 0, y: 0, z: 0)
    
    private enum Constant {
        static let dividCount: Int = 8
        static let lineColor: CGColor = UIColor.gray.cgColor
        static let graphXColor = UIColor.red.cgColor
        static let graphYColor = UIColor.green.cgColor
        static let graphZColor = UIColor.blue.cgColor
        static let lineWidth: CGFloat = 2
        static let graphBaseCount: CGFloat = 8
        static let graphPointersCount: CGFloat = 600
        static let multiplyer: CGFloat = 100
    }
    
    override func draw(_ rect: CGRect) {
            let layer = CAShapeLayer()
            let path = UIBezierPath()
            
            let xOffset = self.frame.width / CGFloat(Constant.dividCount)
            let yOffset = self.frame.height / CGFloat(Constant.dividCount)
            var xpointer: CGFloat = 0
            var ypointer: CGFloat = 0
            let xMaxPointer: CGFloat = self.frame.width
            let yMaxPointer: CGFloat = self.frame.height
        
            var count = 1
            
            while (count < Constant.dividCount) {
                count += 1
                xpointer += xOffset
                path.move(to: CGPoint(x: xpointer, y: 0))
                let newXPosition = CGPoint(x: xpointer, y: yMaxPointer)
                path.addLine(to: newXPosition)

                ypointer += yOffset
                path.move(to: CGPoint(x: 0, y: ypointer))
                let newYPosition = CGPoint(x: xMaxPointer, y: ypointer)
                path.addLine(to: newYPosition)
            }
            
            layer.fillColor = UIColor.black.cgColor
            layer.strokeColor = Constant.lineColor
            layer.lineWidth = 1
            layer.path = path.cgPath
            self.layer.addSublayer(layer)
    }
    
    func drawGraph(data: [MotionValue]) {
        let layerX = CAShapeLayer()
        let layerY = CAShapeLayer()
        let layerZ = CAShapeLayer()
        let pathX = UIBezierPath()
        let pathY = UIBezierPath()
        let pathZ = UIBezierPath()
        
        let offset = self.frame.width / Constant.graphPointersCount
        let initHeight: CGFloat = self.frame.height / 2
        var pointer: CGFloat = 0
        
        pathX.move(to: CGPoint(x: pointer, y: initHeight))
        pathY.move(to: CGPoint(x: pointer, y: initHeight))
        pathZ.move(to: CGPoint(x: pointer, y: initHeight))
        
        for dot in data {
            pointer += offset
            
            let newPositionX = CGPoint(x: pointer, y: initHeight + dot.x)
            let newPositionY = CGPoint(x: pointer, y: initHeight + dot.y)
            let newPositionZ = CGPoint(x: pointer, y: initHeight + dot.z)
            
            pathX.addLine(to: newPositionX)
            pathY.addLine(to: newPositionY)
            pathZ.addLine(to: newPositionZ)
        }
        
        layerX.fillColor = Constant.graphXColor
        layerY.fillColor = Constant.graphYColor
        layerZ.fillColor = Constant.graphZColor
        
        layerX.strokeColor = Constant.graphXColor
        layerY.strokeColor = Constant.graphYColor
        layerZ.strokeColor = Constant.graphZColor
        
        layerX.lineWidth = Constant.lineWidth
        layerY.lineWidth = Constant.lineWidth
        layerZ.lineWidth = Constant.lineWidth
        
        layerX.path = pathX.cgPath
        layerY.path = pathY.cgPath
        layerZ.path = pathZ.cgPath
        
        self.layer.addSublayer(layerX)
        self.layer.addSublayer(layerY)
        self.layer.addSublayer(layerZ)
    }
    
    func drawGraph(data: MotionValue?) {
        
        let layerX = CAShapeLayer()
        let layerY = CAShapeLayer()
        let layerZ = CAShapeLayer()
        let pathX = UIBezierPath()
        let pathY = UIBezierPath()
        let pathZ = UIBezierPath()
        
        let offset = self.frame.width / Constant.graphPointersCount
        let initHeight: CGFloat = self.frame.height / 2
        var pointer: CGFloat = offset * CGFloat(index)
        pathX.move(to: CGPoint(x: pointer, y: initHeight + previousMotion.x * Constant.multiplyer))
        pathY.move(to: CGPoint(x: pointer, y: initHeight + previousMotion.y * Constant.multiplyer))
        pathZ.move(to: CGPoint(x: pointer, y: initHeight + previousMotion.z * Constant.multiplyer))
        
        index += 1
        previousMotion = data ?? MotionValue(timestamp: TimeInterval(), x: 0, y: 0, z: 0)
        pointer = offset * CGFloat(index)
        
        let newPositionX = CGPoint(x: pointer, y: initHeight + (data?.x ?? 0) * Constant.multiplyer)
        let newPositionY = CGPoint(x: pointer, y: initHeight + (data?.y ?? 0) * Constant.multiplyer)
        let newPositionZ = CGPoint(x: pointer, y: initHeight + (data?.z ?? 0) * Constant.multiplyer)
        
        pathX.addLine(to: newPositionX)
        pathY.addLine(to: newPositionY)
        pathZ.addLine(to: newPositionZ)
        
        layerX.fillColor = Constant.graphXColor
        layerY.fillColor = Constant.graphYColor
        layerZ.fillColor = Constant.graphZColor
        
        layerX.strokeColor = Constant.graphXColor
        layerY.strokeColor = Constant.graphYColor
        layerZ.strokeColor = Constant.graphZColor
        
        layerX.lineWidth = Constant.lineWidth
        layerY.lineWidth = Constant.lineWidth
        layerZ.lineWidth = Constant.lineWidth
        
        layerX.path = pathX.cgPath
        layerY.path = pathY.cgPath
        layerZ.path = pathZ.cgPath
        
        self.layer.addSublayer(layerX)
        self.layer.addSublayer(layerY)
        self.layer.addSublayer(layerZ)
    }
}
