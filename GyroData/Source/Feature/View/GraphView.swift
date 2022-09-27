//
//  GraphView.swift
//  TestGyroData
//
//  Created by 엄철찬 on 2022/09/25.
//


import Foundation
import UIKit


enum GraphType {
    case show,play,measure
}

class GraphView : UIView {
    
    init(id:GraphType, xPoints:[Double], yPoints:[Double], zPoints:[Double]){
        
        self.id = id
        
        self.xPoints = [0.0] + xPoints
        self.yPoints = [0.0] + yPoints
        self.zPoints = [0.0] + zPoints
        
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let id : GraphType

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
    
    var drawable : Bool = false
    let margin = Constants.margin
    var weight : CGFloat = 10
    var measuredTime = 599
    var elapsedTime = 0
    var isOverflow : Bool = false
    
    lazy var columnXPoint = { (column : Int) -> CGFloat in
        let spacing = (self.frame.width - self.margin * 2) / CGFloat(self.measuredTime)
        return CGFloat(column) * spacing + self.margin   //공백 더해서
    }
    
    lazy var columnYPoint = { (graphPoint : Double) -> CGFloat in
        let y = CGFloat(graphPoint) * self.weight / CGFloat(Constants.calibration)
        return self.frame.height / 2 - y
    }

    override func draw(_ rect: CGRect) {
        
        if id == .show {
            preview()
        } else {
            if drawable {
                
                if isOverflow {
                    Constants.calibration *= 1.2
                    
                    overflow(path: xPath, points: xPoints, color: xColor)
                    overflow(path: yPath, points: yPoints, color: yColor)
                    overflow(path: zPath, points: zPoints, color: zColor)
                    
                    isOverflow = false
                }
                
                drawGraph(path: xPath, next: xPoint, points: &xPoints, color: xColor, time: elapsedTime)
                drawGraph(path: yPath, next: yPoint, points: &yPoints, color: yColor, time: elapsedTime)
                drawGraph(path: zPath, next: zPoint, points: &zPoints, color: zColor, time: elapsedTime)
                
                elapsedTime += 1
                
            }
        }
        
    }
    
    func preview(){
        eachPreview(path: xPath, points: xPoints, color: xColor)
        eachPreview(path: yPath, points: yPoints, color: yColor)
        eachPreview(path: zPath, points: zPoints, color: zColor)
    }
    
    func eachPreview(path:UIBezierPath, points:[Double], color:UIColor){
        path.move(to: CGPoint(x: columnXPoint(0), y: columnYPoint(points[0])))
        for i in 1..<points.count{
            path.addLine(to: CGPoint(x: columnXPoint(i), y: columnYPoint(points[i])))
        }
        color.setFill()
        color.setStroke()
        path.stroke()
    }
    
    func drawGraph(path:UIBezierPath, next:Double, points:inout [Double],color:UIColor,time:Int){
        color.setFill()
        color.setStroke()
        path.move(to: CGPoint(x: columnXPoint(time), y: columnYPoint(points[time]) ) )
        points.append(next)
        let nextPoint = CGPoint(x: columnXPoint(time + 1), y: columnYPoint(points[time + 1]) )
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
    
    func overflow(path:UIBezierPath,points:[Double],color:UIColor){
        path.removeAllPoints()
        path.move(to: CGPoint(x:columnXPoint(0), y: columnYPoint(points[0]) ))
        for i in 0..<points.count {
            let nextPoint = CGPoint(x: columnXPoint(i), y: columnYPoint(points[i]) )
            path.addLine(to: nextPoint)
        }
        color.setFill()
        color.setStroke()
        path.stroke()
    }
    
    func getData(x:Double,y:Double,z:Double){
        self.xPoint = x
        self.yPoint = y
        self.zPoint = z
    }


}




