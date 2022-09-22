//
//  GraphView.swift
//  GyroData
//
//  Created by 신동원 on 2022/09/23.
//

import UIKit

class GraphBuffer {
    
    var array: [CGFloat?]
    var index = 0
    var count: Int {
        return array.count
    }
    init(count: Int) {
        array = Array(repeating: nil, count: count)
    }
    
    func resetToValue(_ value: CGFloat) {
        let count = array.count
        array = Array(repeating: value, count: count)
    }
    func write(_ element: CGFloat) {
        array[index % array.count] = element
        index += 1
    }
    func nextItems() -> [CGFloat] {
        var result = Array<CGFloat?>()
        for loop in 0..<array.count {
            result.append(array[(loop+index) % array.count])
        }
        return result.compactMap { $0 }
    }
}

class GraphView: UIView {
    
    public var maxValue: CGFloat = 50
    public var minValue: CGFloat = -50
    var graphSwipeAnimation = false
    let animation = CABasicAnimation(keyPath: "path")
    
    public var drawPoints: Bool = true
//    {
//        didSet {
//            guard let layer = self.layer as? CAShapeLayer else { return }
//            layer.path = makePath().path
//        }
//    }
    
    public var points: GraphBuffer?
//    {
//        didSet {
//            guard let layer = self.layer as? CAShapeLayer else { return }
//            if oldValue == nil {
//                layer.path = makePath().path
//            }
//        }
//    }
    
    static override var layerClass: AnyClass {
        return CAShapeLayer.self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setup() {
        guard let layer = self.layer as? CAShapeLayer else { return }
        layer.strokeColor = UIColor.black.cgColor
        //layer.fillColor = UIColor.clear.cgColor
        layer.lineWidth = 1
        
    }
    
    public func reset() {
        guard let layer = self.layer as? CAShapeLayer else { return }
        points?.resetToValue(0)
        layer.path = makePath().path
    }
    
    public func animateNewValue(_ value: CGFloat, duration: Double = 0.0) {
        guard let layer = self.layer as? CAShapeLayer else { return }
        let oldPathInfo = makePath(nextValue: value) // 이전 경로 정보와 새 포인트로 경로 생성
        
        animation.duration = duration
        
        // 이전 경로로 애니메이션 시작
        animation.fromValue = oldPathInfo.path
        
        //x축 1포인트 만큼 왼쪽으로 이동한 경로에 애니메이션 적용
        if graphSwipeAnimation {
            var transform = CGAffineTransform(translationX: -oldPathInfo.nextWidth, y: 0)
            animation.toValue = oldPathInfo.path.copy(using: &transform)
        }
        
        layer.add(animation, forKey: nil)
        
        // Update the array of points with the new point
        points?.write(value)
        
        // After a brief pause to let the animation begin, install the path for the new points.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            layer.path = self.makePath().path
        }
    }
    /**
     Build a path from our points array, plus an optional extra value (which we will animateion
     */
    private func makePath(nextValue: CGFloat? = nil) -> (path: CGPath, nextWidth: CGFloat) {
        guard let points = points else {
            (layer as? CAShapeLayer)?.path = nil
            return (CGMutablePath(), 0)
        }
        
        let nextWidth = bounds.width / (CGFloat(points.count) - 1)
        let range = minValue - maxValue
        let nextHeight = bounds.height / range
        
        let path = CGMutablePath()
        
        for (index, value) in points.nextItems().enumerated() {
            let x = xForIndex(index, nextWidth)
            if !graphSwipeAnimation && bounds.width <= x {
                graphSwipeAnimation = true
            }
            let y = yForValue(value, nextHeight)
            let newPoint = CGPoint(x: x, y: y)
            if index == 0 {
                path.move(to: newPoint)
            } else {
                path.addLine(to: newPoint)
                if drawPoints {
                    let rect = CGRect(x: x, y: y, width: 0, height: 0)
                    path.addRect(rect)
                    path.move(to: CGPoint(x: x, y: y))
                }
            }
        }
//        if let extraValue = nextValue {
//            let x = xForIndex(points.count, nextWidth)
//            let y = yForValue(extraValue, nextHeight)
//            path.addLine(to: CGPoint(x: x, y: y))
//        }
        
        return (path, nextWidth)
    }
    
    func xForIndex(_ index: Int, _ nextWidth: CGFloat) -> CGFloat {
        return CGFloat(index) * nextWidth + bounds.origin.x
    }
    
    func yForValue(_ value: CGFloat, _ nextHeight: CGFloat) -> CGFloat {
        return bounds.height / 2 + value * nextHeight + bounds.origin.y
    }
}
