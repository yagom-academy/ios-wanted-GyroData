//
//  GraphView.swift
//  GyroData
//
//  Created by 정재근 on 2022/12/26.
//

import UIKit
import Foundation

enum GraphColor {
    static let x: UIColor = .red
    static let y: UIColor = .green
    static let z: UIColor = .blue
}

class GraphView: UIView {
    // MARK: - View
    private lazy var xLabel: UILabel = {
        let label = UILabel()
        label.text = "x: 0"
        label.textColor = GraphColor.x
        label.font = UIFont.systemFont(ofSize: 12)
        
        return label
    }()
    
    private lazy var yLabel: UILabel = {
        let label = UILabel()
        label.text = "y: 0"
        label.textColor = GraphColor.y
        label.font = UIFont.systemFont(ofSize: 12)
        
        return label
    }()
    
    private lazy var zLabel: UILabel = {
        let label = UILabel()
        label.text = "z: 0"
        label.textColor = GraphColor.z
        label.font = UIFont.systemFont(ofSize: 12)
        
        return label
    }()
    
    private lazy var hStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            xLabel, yLabel, zLabel
        ])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 30
        
        return stackView
    }()
    
    private var xPoint: Double = 0.0
    private var yPoint: Double = 0.0
    private var zPoint: Double = 0.0
    
    private var xPoints: [Double] = [0.0]
    private var yPoints: [Double] = [0.0]
    private var zPoints: [Double] = [0.0]
    
    private var xPath = UIBezierPath()
    private var yPath = UIBezierPath()
    private var zPath = UIBezierPath()
    
    private var runningTime: Int = 0
    private var max: CGFloat = 0
    private var initalDraw: Int = 0
    var measureTime: Int = 599
    var isOverflowValue: Bool = false
    var isShow: Bool = false
    
    lazy var standardXpoint = { (point: Int) -> CGFloat in
        let margin: CGFloat = 5
        let space = (self.frame.width - margin * 2) / CGFloat(self.measureTime)
        return CGFloat(point) * space + margin
    }
    
    lazy var standardYPoint = { (graphPoint : Double) -> CGFloat in
        let y = CGFloat(graphPoint) / self.max * self.frame.height * 3 / 8
        return self.frame.height / 2 - y
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if initalDraw == 0 {
            initalSetting()
        } else {
            if isShow {
                show()
            } else {
                if isOverflowValue {
                    overflow()
                    isOverflowValue = false
                }
                drawPath()
                runningTime += 1
            }
        }
    }
    
    private func initalSetting() {
        self.backgroundColor = .white
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 3
        self.layer.accessibilityPath?.lineWidth = 2
        stackViewConstraints()
        setBackgroundLayer()
        initalDraw += 1
    }
    
    private func stackViewConstraints() {
        self.addSubview(hStackView)
        self.hStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let layout = [
            self.hStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25),
            self.hStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            self.hStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25)
        ]
        
        NSLayoutConstraint.activate(layout)
    }
    
    private func setBackgroundLayer() {
        let x = self.frame.width / 7
        let y = self.frame.height / 7
        var currentX = x
        var currentY = y
        let path = UIBezierPath()
        
        for _ in 0...6 {
            path.move(to: CGPoint(x: currentX, y: 0))
            path.addLine(to: CGPoint(x: currentX, y: self.frame.height))
            path.move(to: CGPoint(x: 0, y: currentY))
            path.addLine(to: CGPoint(x: self.frame.width, y: currentY))
            currentX += x
            currentY += y
        }
        
        path.close()
        
        let layer = CAShapeLayer()
        layer.path = path.cgPath
        layer.lineWidth = path.lineWidth
        layer.fillColor = UIColor.white.cgColor
        layer.strokeColor = UIColor.lightGray.cgColor
        self.layer.addSublayer(layer)
    }
    
    private func show() {
        self.xLabel.isHidden = true
        self.yLabel.isHidden = true
        self.zLabel.isHidden = true
        
        preview(path: xPath, points: xPoints, color: GraphColor.x)
        preview(path: yPath, points: yPoints, color: GraphColor.y)
        preview(path: zPath, points: zPoints, color: GraphColor.z)
    }
    
    func preview(path:UIBezierPath, points:[Double], color:UIColor){
        path.move(to: CGPoint(x: standardXpoint(0), y: standardYPoint(points[0])))
        for i in 1..<points.count{
            path.addLine(to: CGPoint(x: standardXpoint(i), y: standardYPoint(points[i])))
        }
        color.setFill()
        color.setStroke()
        path.stroke()
    }
    
    private func drawPath() {
        drawGraph(path: xPath, next: xPoint, points: &xPoints, color: GraphColor.x, time: runningTime)
        drawGraph(path: yPath, next: yPoint, points: &yPoints, color: GraphColor.y, time: runningTime)
        drawGraph(path: zPath, next: zPoint, points: &zPoints, color: GraphColor.z, time: runningTime)
    }
    
    private func drawGraph(path:UIBezierPath, next:Double, points:inout [Double],color:UIColor,time:Int){
        color.setFill()
        color.setStroke()
        path.move(to: CGPoint(x: standardXpoint(time), y: standardYPoint(points[time]) ) )
        points.append(next)
        let nextPoint = CGPoint(x: standardXpoint(time + 1), y: standardYPoint(points[time + 1]) )
        path.addLine(to: nextPoint)
        path.stroke()
    }
    
    private func overflow() {
        overflowValue(path: xPath, points: xPoints, color: GraphColor.x)
        overflowValue(path: yPath, points: yPoints, color: GraphColor.y)
        overflowValue(path: zPath, points: zPoints, color: GraphColor.z)
    }
    
    private func overflowValue(path: UIBezierPath, points: [Double], color: UIColor) {
        path.removeAllPoints()
        let firstPoint = CGPoint(x: standardXpoint(0), y: standardYPoint(points[0]))
        path.move(to: firstPoint)
        
        for i in 0..<points.count {
            let nextPoint = CGPoint(x: self.standardXpoint(i), y: standardYPoint(points[i]))
            path.addLine(to: nextPoint)
        }
        color.setFill()
        color.setStroke()
        path.stroke()
    }
    
    func setLabel(x: Double, y: Double, z: Double) {
        self.xLabel.text = "x: \(String(format: "%.3f", x))"
        self.yLabel.text = "y: \(String(format: "%.3f", y))"
        self.zLabel.text = "z: \(String(format: "%.3f", z))"
    }
    
    func getData(x: Double, y: Double, z: Double) {
        self.xPoint = x
        self.yPoint = y
        self.zPoint = z
    }
    
    func setMax(max: CGFloat) {
        self.max = max
    }
    
    func clear() {
        self.runningTime = 0
        [xPath, yPath, zPath].forEach {
            $0.removeAllPoints()
        }
        self.xPoints = [0.0]
        self.yPoints = [0.0]
        self.zPoints = [0.0]
    }
    
    func setShowGraphValue(x: [Double], y: [Double], z: [Double], max: CGFloat, time: Int) {
        self.xPoints = x
        self.yPoints = y
        self.zPoints = z
        self.max = max
        self.measureTime = time
    }
    
}
