//
//  CGContext +.swift
//  GyroData
//
//  Created by ash and som on 2023/02/02.
//

import UIKit

extension CGContext {
    func drawGraphLines(in size: CGSize) {
        self.saveGState()

        let horizontalSpacing = size.width / 8.0
        let verticalSpacing = size.height / 8.0
        let baseLine = size.height / 2.0

        translateBy(x: 0, y: baseLine)

        for index in -4...4 {
            let position = horizontalSpacing * CGFloat(index)

            move(to: CGPoint(x: 0, y: position))
            addLine(to: CGPoint(x: size.width, y: position))
        }

        for index in 1...7 {
            let position = verticalSpacing * CGFloat(index)

            move(to: CGPoint(x: position, y: baseLine))
            addLine(to: CGPoint(x: position, y: -1 * baseLine))
        }

        setStrokeColor(UIColor.black.cgColor)
        strokePath()
        self.restoreGState()
    }
}
