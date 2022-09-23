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

        //CG drawing 함수는 이들이 그리는 context를 알아야 하므로 UIKit 메소드 UIGraphicsGetCurrentContext()를 사용하여 현재 컨텍스트를 가져온다. UIGraphicsGetCurrentContext()는 draw(_:)가 그린것이다
        let context = UIGraphicsGetCurrentContext()!
        let colors = [startColor.cgColor, endColor.cgColor]

        //모든 context는 color space를 가진다. 색상 공간은 CMYK, grayscale 일 수 있지만, 여기서는 RGB 색상 공간을 사용하고 있다
        let colorSpace = CGColorSpaceCreateDeviceRGB()

        //color stops(변수명 colorLocation)은 그라데이션 색상이 변경되는 위치를 나타낸다. 3개의 점도 가질 수 있다
        let colorLocations : [CGFloat] = [0.0, 1.0]

        //실제 그라데이션, 색상공간, 색상들, 색상 정지(color stops)을 생성
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray , locations: colorLocations)!

        //그라데이션을 그린다
        let startPoint = CGPoint.zero
        let endPoint   = CGPoint(x: 0, y: bounds.height)
        context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: [])

        //그라데이션은 draw(_:)의 전체 사각형을 채운다



        //0점 기준선
        let linePath = UIBezierPath()
        let graphHeight = rect.height
        let graphWidth = rect.width

        linePath.move(to: CGPoint(x: Constants.margin, y: graphHeight / 2  ))
        linePath.addLine(to: CGPoint(x: graphWidth - Constants.margin, y: graphHeight / 2  ))

        let color = UIColor(white: 1.0, alpha: 1.0)
        color.setStroke()

        linePath.lineWidth = 1.5
        linePath.stroke()

        
        //값을 수정하여 상한선과 하한선의 거리를 조정할 수 있다
       // let distance = rect.size.height * 3 / 8
        
        //하한선
        linePath.move(to: CGPoint(x: Constants.margin, y: graphHeight * 0.875 ))
        linePath.addLine(to: CGPoint(x: graphWidth - Constants.margin, y: graphHeight * 0.875 ))
        //상한선
        linePath.move(to: CGPoint(x: Constants.margin, y: graphHeight * 0.125))
        linePath.addLine(to: CGPoint(x: graphWidth - Constants.margin, y: graphHeight * 0.125 ))
        
        linePath.lineWidth = 0.7
        linePath.stroke()
        
        
//        //하한보조선
//        linePath.move(to: CGPoint(x: Constants.margin, y: graphHeight / 2  + distance / 2))
//        linePath.addLine(to: CGPoint(x: graphWidth - Constants.margin, y: graphHeight / 2  + distance / 2))
//        //상한보조선
//        linePath.move(to: CGPoint(x: Constants.margin, y: graphHeight / 2  - distance / 2))
//        linePath.addLine(to: CGPoint(x: graphWidth - Constants.margin, y: graphHeight / 2  - distance / 2))
//
//        linePath.lineWidth = 0.3
//        linePath.stroke()

    }

}

