//
//  GraphView.swift
//  GyroData
//
//  Created by 신병기 on 2022/09/26.
//

import UIKit

class GraphView: UIView {
    var width: Double?
    var height: Double?
    
    var realtimeData: [MotionDetailData] = [] {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.width = frame.width
        self.height = frame.height
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        self.drawGrid()
        self.drawGraph()
    }
    
    private func drawGrid() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.systemGray3.cgColor
        
        let path = UIBezierPath()
        
        guard let width = self.width else { return }
        guard let height = self.height else { return }
        let gridInterval = width / 10
        
        for line in 1...10 {
            path.move(to: CGPoint(x: 0, y: Double(line) * gridInterval))
            path.addLine(to: CGPoint(x: width, y: Double(line) * gridInterval))
            
            path.move(to: CGPoint(x: Double(line) * gridInterval, y: 0))
            path.addLine(to: CGPoint(x: Double(line) * gridInterval, y: height))
        }
        
        path.stroke()
        shapeLayer.path = path.cgPath
        self.layer.addSublayer(shapeLayer)
    }
    
    private func drawGraph() {
        let shapeLayer = CAShapeLayer()
        let path = UIBezierPath()
        
        guard let width = self.width else { return }
        guard let height = self.height else { return }
        let timeInterval = width / 600
        let xPosition = timeInterval
        
        guard let data = realtimeData.first else { return }
        let xPath = UIBezierPath()
        let yPath = UIBezierPath()
        let zPath = UIBezierPath()
        
        xPath.move(to: CGPoint(x: 0, y: height / 2))
        yPath.move(to: CGPoint(x: 0, y: height / 2))
        zPath.move(to: CGPoint(x: 0, y: height / 2))
        
        var oldData = data
        for (index, newData) in realtimeData.enumerated() {
            UIColor.systemRed.set()
            xPath.move(to: xPath.currentPoint)
            xPath.addLine(to: CGPoint(x: xPosition * Double(index), y: height / 2 + newData.x * 10))
            xPath.stroke()
            
            UIColor.systemGreen.set()
            yPath.move(to: yPath.currentPoint)
            yPath.addLine(to: CGPoint(x: xPosition * Double(index), y: height / 2 + newData.y * 10))
            yPath.stroke()
            
            UIColor.systemBlue.set()
            zPath.move(to: zPath.currentPoint)
            zPath.addLine(to: CGPoint(x: xPosition * Double(index), y: height / 2 + newData.z * 10))
            zPath.stroke()
            
            oldData = newData
            print(#function, xPath.currentPoint, yPath.currentPoint, zPath.currentPoint)
        }
        
        path.append(xPath)
        path.append(yPath)
        path.append(zPath)
        
        shapeLayer.path = path.cgPath
        self.layer.addSublayer(shapeLayer)
    }
    
    func setData(data: MotionDetailData) {
        realtimeData.append(data)
    }
}
