//
//  GraphSegmentView.swift
//  GyroData
//
//  Created by Wonbi on 2023/02/05.
//

import UIKit

struct MotionData: MotionDataType {
    var x: Double
    var y: Double
    var z: Double
}

final class GraphSegmentView: UIView {
    static let capacity: Double = 30.0
    private var scale: Double {
        didSet {
            setNeedsDisplay()
        }
    }
    private var dataWidth: CGFloat {
        return bounds.width / GraphSegmentView.capacity
    }
    
    private(set) var dataPoints = [MotionData]() {
        didSet {
            setNeedsDisplay()
        }
    }
    private let startPoint: MotionData
    var isFull: Bool {
        return dataPoints.count == Int(GraphSegmentView.capacity)
    }
    
    init(frame: CGRect, scale: Double, startPoint: MotionData = MotionData(x: 0, y: 0, z: 0)) {
        self.startPoint = startPoint
        self.scale = scale
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addData(_ data: MotionDataType) {
        let data = MotionData(x: data.x, y: data.y, z: data.z)
        
        dataPoints.append(data)
    }
    
    func setScale(to scale: Double) {
        self.scale = scale
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.setShouldAntialias(false)
        context.translateBy(x: 0, y: bounds.size.height / 2.0)
        
        drawZ(at: context)
        drawY(at: context)
        drawX(at: context)
    }
    
    private func drawX(at context: CGContext) {
        context.setStrokeColor(GraphView.segmentColor[0].cgColor)
        
        context.move(to: CGPoint(x: 0, y: startPoint.x * scale))
        
        for (pointIndex, dataPoint) in dataPoints.enumerated() {
            context.addLine(to: CGPoint(x: dataWidth * CGFloat(pointIndex + 1), y: dataPoint.x * scale))
        }
        
        context.strokePath()
    }
    
    private func drawY(at context: CGContext) {
        context.setStrokeColor(GraphView.segmentColor[1].cgColor)
        
        context.move(to: CGPoint(x: 0, y: startPoint.y * scale))
        
        for (pointIndex, dataPoint) in dataPoints.enumerated() {
            context.addLine(to: CGPoint(x: dataWidth * CGFloat(pointIndex + 1), y: dataPoint.y * scale))
        }
        
        context.strokePath()
    }
    
    private func drawZ(at context: CGContext) {
        context.setStrokeColor(GraphView.segmentColor[2].cgColor)
        
        context.move(to: CGPoint(x: 0, y: -startPoint.z * scale))
        
        for (pointIndex, dataPoint) in dataPoints.enumerated() {
            context.addLine(to: CGPoint(x: dataWidth * CGFloat(pointIndex + 1), y: -dataPoint.z * scale))
        }
        
        context.strokePath()
    }
}
