//
//  RealTimeGraph.swift
//  GyroData
//
//  Created by 엄철찬 on 2022/09/23.
//

import Foundation
import UIKit

class RealTimeGraph : UIView {

    var xColor : UIColor = .red
    var yColor : UIColor = .green
    var zColor : UIColor = .blue
    
    var xPoint : Double  = 0.0
    var yPoint : Double  = 0.0
    var zPoint : Double  = 0.0
    
    var xPoints : [Double] = [0.0]
    var yPoints : [Double] = [0.0]
    var zPoints : [Double] = [0.0]

    let xPath = UIBezierPath()
    let yPath = UIBezierPath()
    let zPath = UIBezierPath()
    
    lazy var columnXPoint = { (column : Int) -> CGFloat in
        let spacing = self.frame.width / CGFloat(self.measuredTime)
        return CGFloat(column) * spacing + 10   //공백 더해서
    }
    lazy var columnYPoint = { (graphPoint : Double) -> CGFloat in
        let y = CGFloat(graphPoint) * self.weight / CGFloat(Constants.calibration)
        return self.frame.height / 2 - y
    }
    
    var weight : CGFloat = 10
    
    var measuredTime = 600
    
    var elapsedTime = 0
    
    var isOverflow : Bool = false

    override func draw(_ rect: CGRect) {
        
        if isOverflow {
            Constants.calibration *= 1.2
            
            overflow(path: xPath, points: xPoints, color: xColor, calibration: Constants.calibration)
            overflow(path: yPath, points: yPoints, color: yColor, calibration: Constants.calibration)
            overflow(path: zPath, points: zPoints, color: zColor, calibration: Constants.calibration)

            isOverflow = false

        }
        
        drawGraph(path: xPath, next: xPoint, points: &xPoints, color: xColor, time: elapsedTime, calibration: Constants.calibration)
        drawGraph(path: yPath, next: yPoint, points: &yPoints, color: yColor, time: elapsedTime, calibration: Constants.calibration)
        drawGraph(path: zPath, next: zPoint, points: &zPoints, color: zColor, time: elapsedTime, calibration: Constants.calibration)
        
        elapsedTime += 1
    }
    
    func drawGraph(path:UIBezierPath,next:Double, points:inout [Double],color:UIColor,time:Int,calibration:Double){
        color.setFill()
        color.setStroke()
        path.move(to: CGPoint(x: columnXPoint(time), y: columnYPoint(points[time]) ) ) //columnYPoint(points[time]) ) )
        points.append(next)
        let nextPoint = CGPoint(x: columnXPoint(time + 1), y: columnYPoint(points[time + 1])  )
        path.addLine(to: nextPoint)
        path.stroke()
    }
    
    func erase(){
        Constants.calibration = 1.0
        elapsedTime = 0
        xPath.removeAllPoints()
        yPath.removeAllPoints()
        zPath.removeAllPoints()
        xPoints = [0.0]
        yPoints = [0.0]
        zPoints = [0.0]
    }
    
    func overflow(path:UIBezierPath,points:[Double],color:UIColor,calibration:Double){
        path.removeAllPoints()
        path.move(to: CGPoint(x: columnXPoint(0), y:columnYPoint(points[0]) ))
        for i in 0..<points.count {
            let nextPoint = CGPoint(x: columnXPoint(i), y: columnYPoint(points[i]) )
            path.addLine(to: nextPoint)
        }
        color.setFill()
        color.setStroke()
        path.stroke()
    }


}



