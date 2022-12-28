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
    
    //var zeroPath: UIBezierPath! //TODO: 격자용으로 만들었는데 모했읍니다..ㅜㅜ
    
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
        backgroundColor = .lightGray
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
        
        //zeroPath.move(to: CGPoint(x: 0, y: self.frame.height))
    }
    
    func drawNewData(graphData: GraphPoint) {
        currentX += self.frame.width / 60
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
}
