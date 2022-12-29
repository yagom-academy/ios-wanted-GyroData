//
//  GraphView.swift
//  GyroData
//
//  Created by minsson on 2022/12/27.
//

import UIKit

protocol GraphDrawable {
    var data: MeasuredData? { get }
    
    func retrieveData(data: MeasuredData?)
    func startDraw()
    func stopDraw()
    
}

protocol TickReceivable {
    func receive(x: Double, y: Double, z: Double)
}

final class GraphView: UIView, TickReceivable {
    private enum Configuration {
        static var lineColors: [UIColor] = [.red, .green, .blue]
        static let lineWidth: CGFloat = 1
    }
    
    var data: MeasuredData?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GraphView {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let measuredData = self.data else {
            return
        }
        
        drawGraph(of: measuredData)
    }
    
    func receive(x: Double, y: Double, z: Double) {
        
    }
    
    func retrieveData(data: MeasuredData?) {
        self.data = data
    }
}

private extension GraphView {
    func drawGraph(of measuredData: MeasuredData) {
        let zeroX: CGFloat = 0
        let zeroY: CGFloat = self.frame.height / CGFloat(2)
        let xInterval = self.frame.width / CGFloat(measuredData.measuredTime * 10)
        
        let sensorData: [[Double]] = [
            measuredData.sensorData.axisX,
            measuredData.sensorData.axisY,
            measuredData.sensorData.axisZ
        ]
        
        sensorData.forEach { eachAxisData in
            let path = UIBezierPath()
            let lineColor: UIColor = Configuration.lineColors.removeFirst()
            
            path.move(to: CGPoint(x: zeroX, y: zeroY))
            path.lineWidth = Configuration.lineWidth
            lineColor.setStroke()
            
            path.drawGraph(strideBy: xInterval, with: eachAxisData, axisY: zeroY)
            path.stroke()
        }
    }
}




