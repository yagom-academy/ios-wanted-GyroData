//
//  GraphView.swift
//  GyroData
//
//  Created by 엄철찬 on 2022/09/23.
//

import Foundation
import UIKit

class GraphView : UIView {
    
//    private struct Constants {
//        static let cornerRadiusSize = CGSize(width: 20.0, height: 20.0)
//        static let margin: CGFloat = 10.0
//        static let topBorder: CGFloat = 60
//        static let bottomBorder: CGFloat = 50
//        static let colorAlpha: CGFloat = 0.7
//        static let colorAlphaForSubLine : CGFloat = 0.3
//        static let circleDiameter: CGFloat = 5.0
//        static let maxPoint : CGFloat = 140
//    }
    
    //그라데이션을 위한 시작 색상과 끝 색상
    var startColor : UIColor = .lightGray
    var endColor   : UIColor = .gray
    
    var xPoints : [Double]
    var yPoints : [Double]
    var zPoints : [Double]
    
    // set up the points line
    let xPath = UIBezierPath()
    let yPath = UIBezierPath()
    let zPath = UIBezierPath()
    
    
    var xLineLayer = CAShapeLayer()
    var yLineLayer = CAShapeLayer()
    var zLineLayer = CAShapeLayer()
    
    let id : String

    
    
    init(id:String,xPoints:[Double], yPoints:[Double], zPoints:[Double]){
        
        self.id = id
        
        self.xPoints = xPoints
        self.yPoints = yPoints
        self.zPoints = zPoints
        
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        
        let width  = rect.width
        let height = rect.height
        
        //x-point 계산
        let margin = Constants.margin
        let graphWidth = width - margin * 2
        let columnXPoint = { (column : Double) -> CGFloat in
            //gap between points
            let spacing = graphWidth / CGFloat(self.xPoints.count - 1)
            return CGFloat(column) * spacing + margin
        }
        
        //y-point 계산
//        let topBorder    = Constants.topBorder
//        let bottomBorder = Constants.bottomBorder
//        let graphHeight  = height - topBorder - bottomBorder
//        let maxValue     = Constants.maxPoint
        
        var maxValue : Double = 80
        
        let graphHeight = self.frame.height
        
        let columnYPoint = { (graphPoint : Double) -> CGFloat in
            let y = CGFloat(graphPoint) / CGFloat(maxValue) * (graphHeight - Constants.graphHeightPadding * 2)
            return graphHeight / 2 - y
        }
        
        
        
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
        
      
        //draw the xline graph
        UIColor.red.setFill()
        UIColor.red.setStroke()
        
        
        //go xPath start of line
        xPath.move(to: CGPoint(x: columnXPoint(0), y: columnYPoint(self.xPoints[0])))
        
        //add points for each item in the xPoints array
        //at the correct (x,y) for the point
        for i in 1..<self.xPoints.count {
            let nextPoint = CGPoint(x: columnXPoint(Double(i)), y: columnYPoint(self.xPoints[i]))
            xPath.addLine(to: nextPoint)
        }
//        xPath.stroke()
        if self.id == "review"{
            xPath.stroke()
        }
        //draw the yline graph
        UIColor.green.setFill()
        UIColor.green.setStroke()
        
        
        //go to start of line
        yPath.move(to: CGPoint(x: columnXPoint(0), y: columnYPoint(yPoints[0])))
        
        //add points for each item in the xPoints array
        //at the correct (x,y) for the point
        for i in 1..<yPoints.count {
            let nextPoint = CGPoint(x: columnXPoint(Double(i)), y: columnYPoint(yPoints[i]))
            yPath.addLine(to: nextPoint)
        }
        if self.id == "review"{
            yPath.stroke()
        }
     //   yPath.stroke()
        
        
        //draw the zline graph
        UIColor.blue.setFill()
        UIColor.blue.setStroke()
        
        
        //go to start of line
        zPath.move(to: CGPoint(x: columnXPoint(0), y: columnYPoint(zPoints[0])))
        
        //add points for each item in the xPoints array
        //at the correct (x,y) for the point
        for i in 1..<zPoints.count {
            let nextPoint = CGPoint(x: columnXPoint(Double(i)), y: columnYPoint(zPoints[i]))
            zPath.addLine(to: nextPoint)
        }
        
   //     zPath.stroke()
        
        if self.id == "review"{
            zPath.stroke()
        }

        //draw horizontal graph lines on the top of everything
        let linePath = UIBezierPath()
        
        linePath.move(to: CGPoint(x: margin, y: graphHeight / 2  ))
        linePath.addLine(to: CGPoint(x: width - margin, y: graphHeight / 2  ))
  
        let color = UIColor(white: 1.0, alpha: 1)
        color.setStroke()
        
        linePath.lineWidth = 1.0
        linePath.stroke()
        
        
        
        
        //animation
//        xLineLayer.path = xPath.cgPath
//        xLineLayer.strokeColor = UIColor.red.cgColor
//        xLineLayer.fillColor = nil
//        xLineLayer.lineWidth = 1
//        self.layer.addSublayer(xLineLayer)
//
//        yLineLayer.path = yPath.cgPath
//        yLineLayer.strokeColor = UIColor.green.cgColor
//        yLineLayer.fillColor = nil
//        yLineLayer.lineWidth = 1
//        self.layer.addSublayer(yLineLayer)
//
//        zLineLayer.path = zPath.cgPath
//        zLineLayer.strokeColor = UIColor.blue.cgColor
//        zLineLayer.fillColor = nil
//        zLineLayer.lineWidth = 1
//        self.layer.addSublayer(zLineLayer)
        
    }
    
    func startGraphDrawing(){
        xLineLayer.path = xPath.cgPath
        xLineLayer.strokeColor = UIColor.red.cgColor
        xLineLayer.fillColor = nil
        xLineLayer.lineWidth = 1
        self.layer.addSublayer(xLineLayer)
        
        yLineLayer.path = yPath.cgPath
        yLineLayer.strokeColor = UIColor.green.cgColor
        yLineLayer.fillColor = nil
        yLineLayer.lineWidth = 1
        self.layer.addSublayer(yLineLayer)
        
        zLineLayer.path = zPath.cgPath
        zLineLayer.strokeColor = UIColor.blue.cgColor
        zLineLayer.fillColor = nil
        zLineLayer.lineWidth = 1
        self.layer.addSublayer(zLineLayer)
        layer.speed = 1.0
        // strokeEnd -> 끝 점 지정 0-1까지의 값을 가짐
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 60
        
        xLineLayer.add(animation, forKey: "lineAnimation")
        yLineLayer.add(animation, forKey: "lineAnimation")
        zLineLayer.add(animation, forKey: "lineAnimation")
        
    }
    
    func pauseAnimation(){
        let pausedTime = layer.convertTime(CACurrentMediaTime(), from: nil)
        layer.speed = 0.0
        layer.timeOffset = pausedTime
    }
    
    func resumeAnimation(){
        let pausedTime = layer.timeOffset
        layer.speed = 1.0
        layer.timeOffset = 0.0
        layer.beginTime = 0.0
        let timeSincePause = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        layer.beginTime = timeSincePause
    }
    
}
