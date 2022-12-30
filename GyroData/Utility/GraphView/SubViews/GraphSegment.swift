//
//  GraphSegment.swift
//  GyroData
//
//  Created by Judy on 2022/12/28.
//

import UIKit

final class GraphSegment: UIView {
    private(set) var dataPoint = [Double]()
    private let startPoint: [Double]
    private var valueRange = GraphNumber.initialRange
    private let segmentWidth: CGFloat
    
    init(startPoint: [Double], segmentWidth: CGFloat) {
        self.startPoint = startPoint
        self.segmentWidth = segmentWidth
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.translateBy(x: .zero, y: bounds.size.height / 2.0)
    
        for line in MotionData.allCases {
            context.setStrokeColor(line.color)
            
            let startValue = startPoint[line.rawValue]
            let startPoint = CGPoint(x: bounds.size.width,
                                     y: scaledValue(startValue))
            let endPoint = CGPoint(x: bounds.size.width - segmentWidth,
                                   y: scaledValue(dataPoint[line.rawValue]))
            
            context.move(to: startPoint)
            context.addLine(to: endPoint)
            context.strokePath()
        }
    }
    
    func add(_ motions: [Double]) {
        dataPoint = motions
        setNeedsDisplay()
    }
    
    private func scaledValue(_ value: Double) -> CGFloat {
        if value > valueRange.upperBound {
            valueRange = GraphNumber.lowerBoundRange...(value + (value * 0.2))
        }
        
        let scale = bounds.size.height / (valueRange.upperBound - valueRange.lowerBound)
        
        return CGFloat(value * -scale)
    }
}


