//
//  GraphView.swift
//  GyroData
//
//  Created by 엄철찬 on 2022/09/23.
//

import Foundation
import UIKit


class PlotView:UIView{

    var startColor : UIColor = .init(white: 0.8, alpha: 1)
    var endColor   : UIColor = .init(white: 0.2, alpha: 1)


    override func draw(_ rect: CGRect) {

        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: .allCorners,
                                cornerRadii: Constants.cornerRadiusSize)
        path.addClip()

        let context = UIGraphicsGetCurrentContext()!
        let colors = [startColor.cgColor, endColor.cgColor]

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colorLocations : [CGFloat] = [0.0, 1.0]
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray , locations: colorLocations)!
        let startPoint = CGPoint.zero
        let endPoint   = CGPoint(x: 0, y: bounds.height)
        context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: [])

        let linePath = UIBezierPath()
        let graphHeight = rect.height
        let graphWidth = rect.width

        linePath.move(to: CGPoint(x: Constants.margin, y: graphHeight / 2  ))
        linePath.addLine(to: CGPoint(x: graphWidth - Constants.margin, y: graphHeight / 2  ))

        let color = UIColor(white: 1.0, alpha: 1.0)
        color.setStroke()

        linePath.lineWidth = 1.5
        linePath.stroke()

        linePath.move(to: CGPoint(x: Constants.margin, y: graphHeight * 0.875 ))
        linePath.addLine(to: CGPoint(x: graphWidth - Constants.margin, y: graphHeight * 0.875 ))

        linePath.move(to: CGPoint(x: Constants.margin, y: graphHeight * 0.125))
        linePath.addLine(to: CGPoint(x: graphWidth - Constants.margin, y: graphHeight * 0.125 ))
        
        linePath.lineWidth = 0.7
        linePath.stroke()

        linePath.move(to: CGPoint(x: Constants.margin, y: graphHeight * 0.75 ))
        linePath.addLine(to: CGPoint(x: graphWidth - Constants.margin, y: graphHeight * 0.75 ))

        linePath.move(to: CGPoint(x: Constants.margin, y: graphHeight * 0.25))
        linePath.addLine(to: CGPoint(x: graphWidth - Constants.margin, y: graphHeight * 0.25 ))

        linePath.move(to: CGPoint(x: Constants.margin, y: graphHeight * 0.625 ))
        linePath.addLine(to: CGPoint(x: graphWidth - Constants.margin, y: graphHeight * 0.625 ))

        linePath.move(to: CGPoint(x: Constants.margin, y: graphHeight * 0.375))
        linePath.addLine(to: CGPoint(x: graphWidth - Constants.margin, y: graphHeight * 0.375 ))

        linePath.lineWidth = 0.2
        linePath.stroke()
    }

}

