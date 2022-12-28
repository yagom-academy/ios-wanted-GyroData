//
//  GraphSegment.swift
//  GyroData
//
//  Created by Judy on 2022/12/28.
//

import UIKit

class GraphSegment: UIView {
    private(set) var dataPoint = [Double]()
    private let startPoint: [Double]

    init(startPoint: [Double]) {
        self.startPoint = startPoint
        
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
            let endPoint = CGPoint(x: bounds.size.width - GraphNumber.segmentWidth,
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
        // TODO: y축 범위에 따라 조정하는 메서드 -> 기준값 잡기 + 기준을 넘으면 "측정된 값 + (측정된 값 * 0.2)"으로 기준 조정
        let valueRange = GraphNumber.initialRange
        let scale = bounds.size.height / (valueRange.upperBound - valueRange.lowerBound)
        
        return CGFloat(value * -scale)
    }
}

enum MotionData: Int, CaseIterable {
    case x, y, z
    
    var color: CGColor {
        switch self {
        case .x:
            return UIColor.systemRed.cgColor
        case .y:
            return UIColor.systemGreen.cgColor
        case .z:
            return UIColor.systemBlue.cgColor
        }
    }
}
