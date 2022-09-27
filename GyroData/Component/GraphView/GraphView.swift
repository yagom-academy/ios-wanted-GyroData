//
//  GraphView.swift
//  GyroData
//
//  Created by 신동원 on 2022/09/23.
//

import UIKit

class GraphView: UIView {
    
    public var maxValue: CGFloat = 20
    public var minValue: CGFloat = -20
    var graphSwipeAnimation = false
    var graphData: [GyroJson] = []
    var viewTypeIsPlay: PageType?
    
    public var aPoint: GraphBuffer?
    public var bPoint: GraphBuffer?
    public var cPoint: GraphBuffer?
    
    var xLayer = CAShapeLayer()
    var yLayer = CAShapeLayer()
    var zLayer = CAShapeLayer()

    //애니메이션 사용을 위해 layer 재정의
    static override var layerClass: AnyClass {
        return CAShapeLayer.self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        doInitSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //그래프 속성 설정
    func doInitSetup() {
        designLayer(xLayer, color: .red)
        designLayer(yLayer, color: .green)
        designLayer(zLayer, color: .blue)
    }
    
    private func designLayer(_ layer: CAShapeLayer, color: UIColor) {
        layer.strokeColor = color.cgColor
        layer.fillColor = UIColor.clear.cgColor
        layer.lineWidth = 2
        layer.lineCap = .round
    }
    
    //그래프 초기화 기능 메소드
    public func reset() {
        guard let layer = self.layer as? CAShapeLayer else { return }
        graphSwipeAnimation = false
        aPoint?.resetToValue(nil)
        bPoint?.resetToValue(nil)
        cPoint?.resetToValue(nil)
        layer.path = makePath().aPath
    }
    
    func justShowGraph() {
        graphData.forEach { data in
            let x = CGFloat(data.coodinate.x)
            let y = CGFloat(data.coodinate.y)
            let z = CGFloat(data.coodinate.z)
            animateNewValue(aValue: x, bValue: y, cValue: z)
        }
    }
    
    //이전 좌표, 현재 좌표를 이용하여 변화를 애니메이션 처리
    public func animateNewValue(aValue: CGFloat, bValue: CGFloat, cValue: CGFloat, duration: Double = 0.0) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        
        //value가 최대 혹은 최소 값을 초과 했을 경우 스케일 재설정
        resetScale([aValue,bValue,cValue])
        
        let oldPathInfo = makePath()
        
        animation.duration = duration
        
        // 이전 경로로 부터 애니메이션 시작
        animation.fromValue = oldPathInfo.aPath
        
        
        //view최대 가로 길이보다 그래프가 늘어나야 할 경우 지난 그래프를 왼쪽으로 한칸 씩 이동시킨다
        //처음부터 적용하면 애니메이션이 깨지는 현상이 발생하여, view의 최대 가로길이가 넘었을 경우 속성을 추가한다
        //x축의 왼쪽으로 1포인트 만큼 이동한 경로에 애니메이션 적용
        if graphSwipeAnimation {
            var transform = CGAffineTransform(translationX: -oldPathInfo.xInterval, y: 0)
            animation.toValue = oldPathInfo.aPath.copy(using: &transform)
        }
        
        if viewTypeIsPlay == .play {
            xLayer.add(animation, forKey: animation.keyPath)
            yLayer.add(animation, forKey: animation.keyPath)
            zLayer.add(animation, forKey: animation.keyPath)
        }
        
                // 새 좌표 업데이트
        aPoint?.write(aValue)
        bPoint?.write(bValue)
        cPoint?.write(cValue)
        
        // 애니메이션이 시작되기 전에 새 포인트의 경로를 설정하게 되면 애니메이션이 매끄럽지 않아, 시간 차를 두었다
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { [weak self] in
            let path = self?.makePath()
            self?.xLayer.path = path?.aPath
            self?.yLayer.path = path?.bPath
            self?.zLayer.path = path?.cPath
        }
    }
    
    //경로 값을 이용해 선을 그린다
    private func makePath() -> (aPath: CGPath, bPath: CGPath, cPath: CGPath, xInterval: CGFloat) {
        guard let aPoint = aPoint, let bPoint = bPoint, let cPoint = cPoint else {
            (layer as? CAShapeLayer)?.path = nil
            return (UIBezierPath().cgPath, UIBezierPath().cgPath, UIBezierPath().cgPath, 0)
        }

        let xInterval = bounds.width / (CGFloat(aPoint.count) - 1)
        let range = minValue - maxValue
        let yInterval = bounds.height / range
        
        let aPath = UIBezierPath()
        let bPath = UIBezierPath()
        let cPath = UIBezierPath()
                
        for (idx, value) in aPoint.nextItems().enumerated() {

            let x = xForIndex(idx, xInterval) //x는 같고 y가 여러개여야한다.
            if !graphSwipeAnimation && bounds.width <= x {
                graphSwipeAnimation = true
            }
            let aY = yForValue(value, yInterval)
            let bY = yForValue(bPoint.nextItems()[idx], yInterval)
            let cY = yForValue(cPoint.nextItems()[idx], yInterval)
            let aCGPoint = CGPoint(x: x, y: aY)
            let bCGPoint = CGPoint(x: x, y: bY)
            let cCGPoint = CGPoint(x: x, y: cY)

            if idx == 0 {
                aPath.move(to: aCGPoint)
                bPath.move(to: bCGPoint)
                cPath.move(to: cCGPoint)
            } else {
                aPath.addLine(to: aCGPoint)
                aPath.move(to: CGPoint(x: x, y: aY))
                bPath.addLine(to: bCGPoint)
                bPath.move(to: CGPoint(x: x, y: bY))
                cPath.addLine(to: cCGPoint)
                cPath.move(to: CGPoint(x: x, y: cY))
            }
        }
        self.layer.addSublayer(xLayer)
        self.layer.addSublayer(yLayer)
        self.layer.addSublayer(zLayer)
        
        return (aPath.cgPath, bPath.cgPath, cPath.cgPath, xInterval)
    }
    
    func xForIndex(_ index: Int, _ xInterval: CGFloat) -> CGFloat {
        return CGFloat(index) * xInterval + bounds.origin.x
    }
    
    func yForValue(_ value: CGFloat, _ yInterval: CGFloat) -> CGFloat {
        return bounds.height / 2 + value * yInterval + bounds.origin.y
    }
    
    func resetScale(_ motionData: [Double]) {

        for value in motionData {
            if value > maxValue {
                maxValue = value + (value * 0.2)
                minValue = (value + (value * 0.2)) * -1
            }
            if value < minValue {
                maxValue = (value + (value * 0.2)) * -1
                minValue = value + (value * 0.2)
            }
        }

    }
}
