//
//  GraphView.swift
//  GyroData
//
//  Created by 리지 on 2023/06/13.
//

import UIKit

final class GraphView: UIView {

    private var graphLayerX: CAShapeLayer?
    private var graphLayerY: CAShapeLayer?
    private var graphLayerZ: CAShapeLayer?
    private var graphPathX: UIBezierPath?
    private var graphPathY: UIBezierPath?
    private var graphPathZ: UIBezierPath?
    
    override init(frame: CGRect) {
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
    
    func drawGraph(with data: [(x: Double, y: Double, z: Double)]) {
        graphPathX = UIBezierPath()
        graphPathY = UIBezierPath()
        graphPathZ = UIBezierPath()
        
        let height = self.bounds.height
        let width = self.bounds.width
        let midY = height / 2
        
        let totalDataPoints = data.count
        let spacing = width / CGFloat(totalDataPoints - 1)
        
        for i in 0..<data.count {
            let valueX: CGFloat = data[i].x
            let valueY: CGFloat = data[i].y
            let valueZ: CGFloat = data[i].z
            let pointX = CGPoint(x: CGFloat(i) * spacing, y: midY + valueX - 5)
            let pointY = CGPoint(x: CGFloat(i) * spacing, y: midY + valueY)
            let pointZ = CGPoint(x: CGFloat(i) * spacing, y: midY + valueZ + 5)
            
            if i == 0 {
                graphPathX?.move(to: pointX)
                graphPathY?.move(to: pointY)
                graphPathZ?.move(to: pointZ)
            } else {
                graphPathX?.addLine(to: pointX)
                graphPathY?.addLine(to: pointY)
                graphPathZ?.addLine(to: pointZ)
            }
        }
        
        graphLayerX?.path = graphPathX?.cgPath
        graphLayerY?.path = graphPathY?.cgPath
        graphLayerZ?.path = graphPathZ?.cgPath
    }
}
