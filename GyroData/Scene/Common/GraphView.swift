//
//  GraphView.swift
//  GyroData
//
//  Created by 백곰, 바드 on 2022/12/27.
//

import UIKit

final class GraphView : UIView {
    
    // MARK: Properties
    
    private let graphType : GraphType
    
    private let xColor: UIColor = .red
    private let yColor: UIColor = .green
    private let zColor: UIColor = .blue
    
    private var xPoint: Double  = 0.0
    private var yPoint: Double  = 0.0
    private var zPoint: Double  = 0.0
    
    private var xPoints: [Double] = [0.0]
    private var yPoints: [Double] = [0.0]
    private var zPoints: [Double] = [0.0]
    
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
    
    init(graphType: GraphType, xPoints: [Double], yPoints: [Double], zPoints: [Double]) {
        self.graphType = graphType
        self.xPoints = xPoints
        self.yPoints = yPoints
        self.zPoints = zPoints
        
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        graphType = .measure
        super.init(coder: coder)
        commonInit()
    }
    
    // MARK: - Methods
    
    override func draw(_ rect: CGRect) {
        switch graphType {
        case .show:
            setupPreview()
        case .play:
            break
        case .measure:
            break
        }
    }
    
    private func commonInit() {
        setupBackgroundcolor(.clear)
    }

    func setupPreview(){
        drawPath(path: xPath, points: xPoints, color: xColor)
        drawPath(path: yPath, points: yPoints, color: yColor)
        drawPath(path: zPath, points: zPoints, color: zColor)
    }
    
    func getData(xPoints: [Double], yPoints: [Double], zPoints: [Double]){
        drawPath(path: xPath, points: xPoints, color: xColor)
        drawPath(path: yPath, points: yPoints, color: yColor)
        drawPath(path: zPath, points: zPoints, color: zColor)
    }
    
    func drawPath(path: UIBezierPath, points: [Double], color: UIColor) {
        var tickPoint = tick
        
        path.move(to: CGPoint(x: 0, y: columnYStartPoint))
        for i in 0..<points.count{
            path.addLine(to: CGPoint(
                x: 0 + tickPoint,
                y: frame.height - (columnYStartPoint + points[i])
            ))
            tickPoint += tick
        }
        color.setStroke()
        path.stroke()
    }
    
    func erase(){
        xPath.removeAllPoints()
        yPath.removeAllPoints()
        zPath.removeAllPoints()
        xPoints = [0.0]
        yPoints = [0.0]
        zPoints = [0.0]
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
