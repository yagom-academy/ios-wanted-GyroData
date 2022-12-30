//
//  GraphView.swift
//  GyroData
//
//  Created by 백곰, 바드 on 2022/12/27.
//

import UIKit

final class GraphView : UIView {
    
    // MARK: Properties
    
    let graphType : GraphType
    
    private let xColor: UIColor = .red
    private let yColor: UIColor = .green
    private let zColor: UIColor = .blue
    
    private var xPoint: Double  = 0.0
    private var yPoint: Double  = 0.0
    private var zPoint: Double  = 0.0
    
    private var xPoints: [Double] = [0.0]
    private var yPoints: [Double] = [0.0]
    private var zPoints: [Double] = [0.0]
    
    private let xPointslayer = CAShapeLayer()
    private let yPointslayer = CAShapeLayer()
    private let zPointslayer = CAShapeLayer()
    
    private let xPath = UIBezierPath()
    private let yPath = UIBezierPath()
    private let zPath = UIBezierPath()
    
    private var drawable: Bool = false
    private var isOverflow: Bool = false
    
    private var columnYStartPoint: CGFloat {
        return frame.height / 2
    }
    
    private var maxYPoint: CGFloat {
        return frame.maxY
    }
    
    private var minYPoint: CGFloat {
        return frame.minY
    }
    
    private var tick: CGFloat {
        return frame.height / 600
    }
    
    // MARK: - Initializers
    
    init() {
        self.graphType = .view
        self.xPoints = []
        self.yPoints = []
        self.zPoints = []
        super.init(frame: .zero)
    }
    
    init(graphType: GraphType, xPoints: [Double], yPoints: [Double], zPoints: [Double]) {
        self.graphType = graphType
        self.xPoints = xPoints
        self.yPoints = yPoints
        self.zPoints = zPoints
        
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        graphType = .play
        super.init(coder: coder)
        commonInit()
    }
    
    // MARK: - Methods
    
    override func draw(_ rect: CGRect) {
        switch graphType {
        case .view:
            setupPreview()
        case .play:
            setupPreview()
//            setupAnimtaion()
        case .draw:
            return
        }
    }
    
    private func commonInit() {
        setupBackgroundcolor(.clear)
    }

    func setupPreview(){
        drawPath(path: xPath, pointsLayer: xPointslayer, points: xPoints, color: xColor)
        drawPath(path: yPath, pointsLayer: yPointslayer, points: yPoints, color: yColor)
        drawPath(path: zPath, pointsLayer: zPointslayer, points: zPoints, color: zColor)
    }
    
    func startAnimation() {
        setupAnimtaion()
    }
    
    func erase(){
        xPath.removeAllPoints()
        yPath.removeAllPoints()
        zPath.removeAllPoints()
        xPoints = [0.0]
        yPoints = [0.0]
        zPoints = [0.0]
    }
    
    private func drawPath(
        path: UIBezierPath,
        pointsLayer: CAShapeLayer,
        points: [Double],
        color: UIColor
    ) {
        var tickPoint = tick
        
        path.move(to: CGPoint(x: 0, y: columnYStartPoint))
        for i in 0..<points.count{
            path.addLine(to: CGPoint(
                x: 0 + tickPoint,
                y: frame.height - (columnYStartPoint + points[i])
            ))
            tickPoint += tick
            pointsLayer.path = path.cgPath
            pointsLayer.fillColor = UIColor.clear.cgColor
            layer.addSublayer(pointsLayer)
        }
        switch graphType {
        case .view:
            color.setStroke()
            pointsLayer.strokeColor = color.cgColor
        case .play:
            UIColor.clear.setStroke()
            pointsLayer.strokeColor = UIColor.clear.cgColor
        case .draw:
            color.setStroke()
            pointsLayer.strokeColor = color.cgColor
        }
    }
    
    func animate(layer: CAShapeLayer, points: [Double], color: UIColor) {
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        guard let sample = layer.path?.boundingBox.height,
        let sample2 = layer.path?.boundingBox.width,
        let sample3 = layer.path?.boundingBoxOfPath.size else { return }
        print(layer.position)
        print(sample)
        print(sample2)
        print(sample3)
        animation.duration = sample
        animation.fromValue = 0
        animation.toValue = 1
        layer.add(animation, forKey: "lineAnimation")
        layer.strokeColor = color.cgColor
        self.layer.addSublayer(layer)
        
    }
    
    private func setupAnimtaion() {
        animate(layer: xPointslayer, points: xPoints, color: xColor)
        animate(layer: yPointslayer, points: yPoints, color: yColor)
        animate(layer: zPointslayer, points: zPoints, color: zColor)
//        let animation = CABasicAnimation(keyPath: "strokeEnd")
//        animation.duration = 60
//        animation.fromValue = 0
//        animation.toValue = 1
//        xPointslayer.add(animation, forKey: "lineAnimation")
//        yPointslayer.add(animation, forKey: "lineAnimation")
//        zPointslayer.add(animation, forKey: "lineAnimation")
//
//        xPointslayer.strokeColor = xColor.cgColor
//        yPointslayer.strokeColor = yColor.cgColor
//        zPointslayer.strokeColor = zColor.cgColor
    }
    
    private func setupBackgroundcolor(_ color: UIColor?) {
        backgroundColor = color
    }
    
    private func checkIsOverflowed() {
        yPoints.forEach {
            if $0 > maxYPoint || $0 < minYPoint {
                isOverflow = false
            } else {
                isOverflow = true
            }
        }
    }
}
