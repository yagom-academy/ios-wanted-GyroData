//
//  GraphView.swift
//  GyroData
//
//  Created by Judy on 2022/12/27.
//

import UIKit

class GraphView: UIView {
    private var segments = [GraphSegment]()
    private var currentSegment: GraphSegment? {
        return segments.last
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.black.cgColor
        self.backgroundColor = .systemBackground
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.drawGridGraph(in: self.bounds.size)
    }
    
    // TODO: 세그먼트를 삭제하고 그래프 지우는 메서드
    func clearSegmanet() {
        
    }
    
    func add(_ motions: [Double]) {
        segments.forEach {
            $0.center.x += bounds.size.width / 600.0
        }
        
        addSegment()
        currentSegment?.add(motions)
    }
    
    private func addSegment() {
        let startPoint: [Double]
        
        if let currentSegment = currentSegment {
            guard currentSegment.dataPoint.isEmpty == false else { return }
            startPoint = currentSegment.dataPoint
        } else {
            startPoint = [0, 0, 0]
        }
        
        let newSegment = GraphSegment(startPoint: startPoint, segmentSize: bounds.size.width / 600.0)
        segments.append(newSegment)
        
        newSegment.backgroundColor = .clear
        
        let segmentWidth = CGFloat(32)
        newSegment.frame = CGRect(x: -segmentWidth, y: 0, width: segmentWidth, height: bounds.size.height)
        self.addSubview(newSegment)
    }
}
