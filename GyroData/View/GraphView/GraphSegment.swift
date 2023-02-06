//
//  GraphSegment.swift
//  GyroData
//
//  Created by ash and som on 2023/02/02.
//

import UIKit

final class GraphSegment: UIView {
    private(set) var dataPoint = [Double]()
    private let startPoint: [Double]
    private var valueRange = GraphContent.initialRange
    private let segmentWidth: CGFloat

    init(startPoint: [Double], segmentWidth: CGFloat) {
        self.startPoint = startPoint
        self.segmentWidth = segmentWidth
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    func add(_ motions: [Double]) {
        dataPoint = motions
        setNeedsDisplay()
    }

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }

        context.translateBy(x: 0, y: bounds.size.height / 2.0)

        for lineIndex in CoordinateData.allCases {
            context.setStrokeColor(lineIndex.color)

            let startValue = startPoint[lineIndex.rawValue]
            let startPoint = CGPoint(x: bounds.size.width,
                                     y: scaledValue(startValue))
            let endPoint = CGPoint(x: bounds.size.width - segmentWidth,
                                   y: scaledValue(dataPoint[lineIndex.rawValue]))

            context.move(to: startPoint)
            context.addLine(to: endPoint)
            context.strokePath()
        }
    }

    private func scaledValue(_ value: Double) -> CGFloat {
        if value > valueRange.upperBound {
            valueRange = GraphContent.lowerBoundRange...(value + (value * 0.2))
        }

        let scale = Double(bounds.size.height) / (valueRange.upperBound - valueRange.lowerBound)

        return CGFloat(floor(value * -scale))
    }
}
