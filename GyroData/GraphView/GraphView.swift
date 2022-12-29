//
//  GraphView.swift
//  GyroData
//
//  Created by minsson on 2022/12/27.
//

import UIKit

protocol GraphDrawable {
    var data: MeasuredData? { get }
    
    func retrieveData(data: MeasuredData)
    func startDraw()
    func stopDraw()
}

protocol TickReceivable {
    func receive(x: Double, y: Double, z: Double)
}

enum DrawMode {
    case image
    case play
}

final class GraphView: UIView, TickReceivable, GraphDrawable {
    func startDraw() {
        
    }
    
    func stopDraw() {
        
    }
    
    func configureDrawMode(_ drawMode: DrawMode) {
        self.drawMode = drawMode
    }
    
    
    private enum Configuration {
        static let lineWidth: CGFloat = 1
    }
    
    var data: MeasuredData?
    var drawMode: DrawMode = .play
    
    private var zeroX: CGFloat = 0
    private lazy var zeroY: CGFloat = self.frame.height / CGFloat(2)
    private var xInterval: CGFloat = 0

    init() {
        super.init(frame: .zero)
        
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GraphView {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        switch drawMode {
        case .play:
            break
        case .image:
            guard let measuredData = self.data else {
                return
            }
            drawGraph(of: measuredData)
        }
    }

    func retrieveData(data: MeasuredData) {
        self.data = data
        
        setNeedsDisplay()
    }
    
    func receive(x: Double, y: Double, z: Double) {
        
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
        
        var lineColors: [UIColor] = [.red, .green, .blue]
        
        sensorData.forEach { eachAxisData in
            let path = UIBezierPath()
            let lineColor: UIColor = lineColors.removeFirst()
            
            path.move(to: CGPoint(x: zeroX, y: zeroY))
            path.lineWidth = Configuration.lineWidth
            lineColor.setStroke()
            
            path.drawGraph(strideBy: xInterval, with: eachAxisData, axisY: zeroY)
            
            path.stroke()
        }
    }
}
