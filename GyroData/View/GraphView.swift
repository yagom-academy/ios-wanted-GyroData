//
//  GraphView.swift
//  GyroData
//
//  Created by 리지 on 2023/06/13.
//

import UIKit
import Combine

final class GraphView: UIView {

    private var graphLayerX: CAShapeLayer?
    private var graphLayerY: CAShapeLayer?
    private var graphLayerZ: CAShapeLayer?
    private var graphPathX: UIBezierPath?
    private var graphPathY: UIBezierPath?
    private var graphPathZ: UIBezierPath?
    
    private let viewModel: TimerModel?
    private var cancellables = Set<AnyCancellable>()
    
    init(frame: CGRect, viewModel: TimerModel?) {
        self.viewModel = viewModel
        super.init(frame: frame)
        self.backgroundColor = .white
        setUpGraphLayerX()
        setUpGraphLayerY()
        setUpGraphLayerZ()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpGraphLayerX() {
        graphLayerX = CAShapeLayer()
        graphLayerX?.strokeColor = UIColor.red.cgColor
        graphLayerX?.lineWidth = 2
        graphLayerX?.fillColor = UIColor.clear.cgColor
        
        guard let graphLayer = graphLayerX else { return }
        layer.addSublayer(graphLayer)
    }
    
    private func setUpGraphLayerY() {
        graphLayerY = CAShapeLayer()
        graphLayerY?.strokeColor = UIColor.green.cgColor
        graphLayerY?.lineWidth = 2
        graphLayerY?.fillColor = UIColor.clear.cgColor
        
        guard let graphLayer = graphLayerY else { return }
        layer.addSublayer(graphLayer)
    }
    
    private func setUpGraphLayerZ() {
        graphLayerZ = CAShapeLayer()
        graphLayerZ?.strokeColor = UIColor.blue.cgColor
        graphLayerZ?.lineWidth = 2
        graphLayerZ?.fillColor = UIColor.clear.cgColor
        
        guard let graphLayer = graphLayerZ else { return }
        layer.addSublayer(graphLayer)
    }
    
    private func drawLine(by standard: Int, _ pointX: CGPoint, _ pointY: CGPoint, _ pointZ: CGPoint) {
        if standard == 0 {
            graphPathX?.move(to: pointX)
            graphPathY?.move(to: pointY)
            graphPathZ?.move(to: pointZ)
        } else {
            graphPathX?.addLine(to: pointX)
            graphPathY?.addLine(to: pointY)
            graphPathZ?.addLine(to: pointZ)
        }
    }
    
    private func matchPath() {
        graphLayerX?.path = graphPathX?.cgPath
        graphLayerY?.path = graphPathY?.cgPath
        graphLayerZ?.path = graphPathZ?.cgPath
    }
    
    private func setUpPoints(with data: [ThreeAxisValue], standard: Int, midY: CGFloat, spacing: CGFloat) {
        let valueX: CGFloat = data[standard].valueX
        
        var valueY: CGFloat = 0
        
        if (midY + valueY) >= midY * 2 || (midY + valueY) <= 0 {
            valueY = valueY + (valueY * 0.2)
        } else {
            valueY = data[standard].valueY
        }
    
        let valueZ: CGFloat = data[standard].valueZ
        let pointX = CGPoint(x: CGFloat(standard) * spacing, y: midY + valueX - 5)
        let pointY = CGPoint(x: CGFloat(standard) * spacing, y: midY + valueY)
        let pointZ = CGPoint(x: CGFloat(standard) * spacing, y: midY + valueZ + 5)
        
        drawLine(by: standard, pointX, pointY, pointZ)
    }
    
    private func isStopButtonTapped(_ timer: Timer) {
        viewModel?.isStop
            .map { $0 == true }
            .sink { _ in
                timer.invalidate()
            }
            .store(in: &cancellables)
    }
}

extension GraphView {
    func drawGraph(with data: [ThreeAxisValue]) {
        graphPathX = UIBezierPath()
        graphPathY = UIBezierPath()
        graphPathZ = UIBezierPath()
        
        let height = self.bounds.height
        let width = self.bounds.width
        let midY = height / 2
        
        let totalDataPoints = data.count
        let spacing = width / CGFloat(totalDataPoints - 1)
        
        for i in 0..<data.count {
            setUpPoints(with: data, standard: i, midY: midY, spacing: spacing)
        }
        matchPath()
    }
    
    func drawGraphByTenthOfASecond(with data: [ThreeAxisValue]) {
        graphPathX = UIBezierPath()
        graphPathY = UIBezierPath()
        graphPathZ = UIBezierPath()
        
        let height = self.bounds.height
        let width = self.bounds.width
        let midY = height / 2

        let totalDataPoints = data.count
        let spacing = width / CGFloat(totalDataPoints - 1)
        
        var currentIndex = 0
        
        let animationTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
            guard currentIndex < data.count else {
                timer.invalidate()
                return
            }
            self?.isStopButtonTapped(timer)
            self?.viewModel?.startTimer()
            self?.setUpPoints(with: data, standard: currentIndex, midY: midY, spacing: spacing)
            currentIndex += 1
            self?.matchPath()
        }
        
        RunLoop.current.add(animationTimer, forMode: .common)
    }
}
