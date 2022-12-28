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
        self.layer.borderWidth = GraphNumber.borderWidth
        self.layer.borderColor = UIColor.black.cgColor
        self.backgroundColor = .systemBackground
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.drawGridGraph(in: self.bounds.size)
    }
    
    func clearSegmanet() {
        segments.forEach {
            $0.removeFromSuperview()
        }
        
        segments.removeAll()
    }
    
    func add(_ motions: [Double]) {
        segments.forEach {
            $0.center.x += GraphNumber.segmentWidth
        }
        
        removeOutofBoundsSegment()
        addSegment()
        currentSegment?.add(motions)
    }
    
    private func addSegment() {
        let startPoint: [Double]
        
        if let currentSegment = currentSegment {
            guard currentSegment.dataPoint.isEmpty == false else { return }
            startPoint = currentSegment.dataPoint
        } else {
            startPoint = GraphNumber.initialPoint
        }
        
        let newSegment = GraphSegment(startPoint: startPoint)
        newSegment.backgroundColor = .clear
        newSegment.frame = CGRect(x: .zero,
                                  y: .zero,
                                  width: GraphNumber.segmentWidth,
                                  height: bounds.size.height)
        
        segments.append(newSegment)
        self.addSubview(newSegment)
    }
    
    private func removeOutofBoundsSegment() {
        segments = segments.filter { segment in
            if segment.frame.origin.x + GraphNumber.segmentWidth >= bounds.size.width {
                segment.removeFromSuperview()
                return false
            }
            
            return true
        }
    }
}

enum GraphNumber {
    static let borderWidth = CGFloat(2)
    static let segmentWidth = CGFloat(3)
    static let initialPoint = [Double.zero, Double.zero, Double.zero]
    static let initialRange = -4.0...4.0
    static let lowerBoundRange = -4.0
}
