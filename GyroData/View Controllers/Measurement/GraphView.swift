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
            if let width = self.width,
               let height = self.height {
                let timeInterval = width / 600
                let xPosition = timeInterval * Double(realtimeData.count - 1)
                setNeedsDisplay(CGRect(origin: CGPoint(x: xPosition, y: 0), size: CGSize(width: timeInterval * 2, height: height)))
            }
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
        xPath.lineWidth = 3
        yPath.lineWidth = 3
        zPath.lineWidth = 3

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
        UIColor.systemRed.set()
        xPath.addLine(to: CGPoint(x: xPosition, y: height / 2 + newData.x * 10))
        xPath.stroke()

        UIColor.systemGreen.set()
        yPath.addLine(to: CGPoint(x: xPosition, y: height / 2 + newData.y * 10))
        yPath.stroke()

        UIColor.systemBlue.set()
        zPath.addLine(to: CGPoint(x: xPosition, y: height / 2 + newData.z * 10))
        zPath.stroke()
        
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
