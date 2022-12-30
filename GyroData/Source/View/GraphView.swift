//
//  GraphView.swift
//  GyroData
//
//  Created by 유한석 on 2022/12/27.
//

import UIKit

final class GraphView: UIView {
    // 이 뷰에 그려질 레이어
    var graphXLayer: CAShapeLayer
    var graphYLayer: CAShapeLayer
    var graphZLayer: CAShapeLayer
    
    //x좌표 변수
    let valueCount: Int
    var xOffset: CGFloat = 0
    var currentX: CGFloat = 0
    
    // xyz별로 그려질 때 필요한 변수
    var XgraphPath: UIBezierPath!
    var YgraphPath: UIBezierPath!
    var ZgraphPath: UIBezierPath!
    
    init(frame: CGRect, valueCount: Int) {
        self.valueCount = valueCount
        self.graphXLayer = CAShapeLayer()
        self.graphYLayer = CAShapeLayer()
        self.graphZLayer = CAShapeLayer()
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        self.layer.borderWidth = 2
    }
    
    required init?(coder: NSCoder) {
        xOffset = 0
        currentX = 0
        self.valueCount = 0
        self.graphXLayer = CAShapeLayer()
        self.graphYLayer = CAShapeLayer()
        self.graphZLayer = CAShapeLayer()
        super.init(coder: coder)
        debugPrint("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        self.drawBackgroundGraph(rect)
    }
    
    func setupViewDefault() {
        layer.sublayers?.forEach({ cALayer in
            cALayer.removeFromSuperlayer()
        })
        graphXLayer = CAShapeLayer()
        graphYLayer = CAShapeLayer()
        graphZLayer = CAShapeLayer()
        
        self.xOffset = self.frame.width / CGFloat(valueCount)
        
        self.XgraphPath = UIBezierPath()
        self.YgraphPath = UIBezierPath()
        self.ZgraphPath = UIBezierPath()
        
        self.layer.addSublayer(graphXLayer)
        self.layer.addSublayer(graphYLayer)
        self.layer.addSublayer(graphZLayer)
        
        graphXLayer.fillColor = nil
        graphXLayer.strokeColor = UIColor.red.cgColor
        graphXLayer.lineWidth = 2
        
        graphYLayer.fillColor = nil
        graphYLayer.strokeColor = UIColor.blue.cgColor
        graphYLayer.lineWidth = 2
        
        graphZLayer.fillColor = nil
        graphZLayer.strokeColor = UIColor.green.cgColor
        graphZLayer.lineWidth = 2
        
        //각 축의 데이터 시작지점 이동
        XgraphPath.move(to: CGPoint(x: 0, y: self.frame.height))
        YgraphPath.move(to: CGPoint(x: 0, y: self.frame.height))
        ZgraphPath.move(to: CGPoint(x: 0, y: self.frame.height))
    }
    
    func drawNewData(graphData: GraphPoint) {
        currentX += self.frame.width / 6000
        let newXPosition = CGPoint(x: CGFloat(currentX), y: self.frame.height/2 - graphData.xValue)
        let newYPosition = CGPoint(x: CGFloat(currentX), y: self.frame.height/2 - graphData.yValue)
        let newZPosition = CGPoint(x: CGFloat(currentX), y: self.frame.height/2 - graphData.zValue)
        
        XgraphPath.addLine(to: newXPosition)
        YgraphPath.addLine(to: newYPosition)
        ZgraphPath.addLine(to: newZPosition)
        
        let newXPath = XgraphPath.cgPath
        let newYPath = YgraphPath.cgPath
        let newZPath = ZgraphPath.cgPath
        
        self.graphXLayer.path = newXPath
        self.graphYLayer.path = newYPath
        self.graphZLayer.path = newZPath
    }
    
    func drawBackgroundGraph(_ rect: CGRect) {
        let colummLinePath = UIBezierPath()
        let rowLinePath = UIBezierPath()
        
        for linePositionX in 0..<Int(rect.size.width) {
            if linePositionX % 40 == 0 {
                let colummStartPoint = CGPoint(x: CGFloat(linePositionX), y: CGFloat(0))
                let colummEndPoint = CGPoint(x: CGFloat(linePositionX), y: rect.size.height)
                
                colummLinePath.move(to: colummStartPoint)
                colummLinePath.addLine(to: colummEndPoint)
            }
        }
        
        for linePositionY in 0..<Int(rect.size.height) {
            if linePositionY % 40 == 0 {
                let rowStartPoint = CGPoint(x: CGFloat(0), y: CGFloat(linePositionY))
                let rowEndPoint = CGPoint(x: rect.size.width, y: CGFloat(linePositionY))
                
                rowLinePath.move(to: rowStartPoint)
                rowLinePath.addLine(to: rowEndPoint)
            }
        }
        
        
        let colummLineLayer = CAShapeLayer()
        let rowLineLayer = CAShapeLayer()
        colummLineLayer.path = colummLinePath.cgPath
        rowLineLayer.path = rowLinePath.cgPath
        colummLineLayer.strokeColor = UIColor.black.cgColor
        rowLineLayer.strokeColor = UIColor.black.cgColor
        colummLineLayer.lineWidth = 0.5
        rowLineLayer.lineWidth = 0.5
        
        self.layer.addSublayer(colummLineLayer)
        self.layer.addSublayer(rowLineLayer)
    }
}
