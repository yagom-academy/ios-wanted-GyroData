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
    
    var realtimeData: [MotionDataItem] = [] {
        didSet {
            if let width = self.width,
               let height = self.height {
                let timeInterval = width / 600
                let xPosition = timeInterval * Double(realtimeData.count - 1)
                setNeedsDisplay(CGRect(origin: CGPoint(x: xPosition, y: 0), size: CGSize(width: timeInterval * 2, height: height)))
            }
        }
    }
    
    var storedData: [MotionDataItem] = [] {
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
        let xPosition = timeInterval * Double(realtimeData.count - 1)
        
        let xPath = UIBezierPath()
        let yPath = UIBezierPath()
        let zPath = UIBezierPath()

        if realtimeData.isEmpty == false {
            if realtimeData.count > 1 {
                let oldData = realtimeData[realtimeData.count - 2]
                xPath.move(to: CGPoint(x: xPosition - timeInterval, y: height / 2 + oldData.x * 10))
                yPath.move(to: CGPoint(x: xPosition - timeInterval, y: height / 2 + oldData.y * 10))
                zPath.move(to: CGPoint(x: xPosition - timeInterval, y: height / 2 + oldData.z * 10))
            } else {
                xPath.move(to: CGPoint(x: 0, y: height / 2))
                yPath.move(to: CGPoint(x: 0, y: height / 2))
                zPath.move(to: CGPoint(x: 0, y: height / 2))
            }
            
            guard let newData = realtimeData.last else { return }
            UIColor.systemRed.withAlphaComponent(0.7).set()
            xPath.addLine(to: CGPoint(x: xPosition, y: height / 2 + newData.x * 10))
            xPath.stroke()
            
            UIColor.systemGreen.withAlphaComponent(0.7).set()
            yPath.addLine(to: CGPoint(x: xPosition, y: height / 2 + newData.y * 10))
            yPath.stroke()
            
            UIColor.systemBlue.withAlphaComponent(0.7).set()
            zPath.addLine(to: CGPoint(x: xPosition, y: height / 2 + newData.z * 10))
            zPath.stroke()
            
        } else if storedData.isEmpty == false {
            xPath.move(to: CGPoint(x: 0, y: height / 2))
            yPath.move(to: CGPoint(x: 0, y: height / 2))
            zPath.move(to: CGPoint(x: 0, y: height / 2))
            
            for (index, newData) in storedData.enumerated() {
                UIColor.systemRed.withAlphaComponent(0.7).set()
                xPath.move(to: xPath.currentPoint)
                xPath.addLine(to: CGPoint(x: timeInterval * Double(index), y: height / 2 + newData.x * 10))
                xPath.stroke()
                
                UIColor.systemGreen.withAlphaComponent(0.7).set()
                yPath.move(to: yPath.currentPoint)
                yPath.addLine(to: CGPoint(x: timeInterval * Double(index), y: height / 2 + newData.y * 10))
                yPath.stroke()
                
                UIColor.systemBlue.withAlphaComponent(0.7).set()
                zPath.move(to: zPath.currentPoint)
                zPath.addLine(to: CGPoint(x: timeInterval * Double(index), y: height / 2 + newData.z * 10))
                zPath.stroke()
            }
        }
        
        path.append(xPath)
        path.append(yPath)
        path.append(zPath)
        
        shapeLayer.path = path.cgPath
        self.layer.addSublayer(shapeLayer)
    }
    
    func setData(data: MotionDataItem) {
        realtimeData.append(data)
    }
}
