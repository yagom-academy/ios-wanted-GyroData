//
//  GraphView.swift
//  GyroData
//
//  Created by Judy on 2022/12/27.
//

import UIKit

class GraphView: UIView {
    private let xDataLabel = MotionLabel(motionData: .x, frame: .zero)
    private let yDataLabel = MotionLabel(motionData: .y, frame: .zero)
    private let zDataLabel = MotionLabel(motionData: .z, frame: .zero)
    private var segmentWidth = GraphNumber.segmentWidth
    private var segmentHeight: Double = .zero
    private let dataStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private var segments = [GraphSegment]()
    private var currentSegment: GraphSegment? {
        return segments.last
    }
    
    var segmentDatas: [[Double]] {
        return segments.map {
            $0.dataPoint
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.drawGridGraph(in: self.bounds.size)
    }
    
    func clearSegmanet() {
        setupLabel(with: GraphNumber.initialPoint)
        
        segmentWidth = GraphNumber.segmentWidth
        segmentHeight = bounds.size.height
        
        segments.forEach {
            $0.removeFromSuperview()
        }
        
        segments.removeAll()
    }
    
    func add(_ motions: [Double]) {
        setupLabel(with: motions)
        
        segments.forEach {
            $0.center.x += segmentWidth
        }
        
        removeOutofBoundsSegment()
        addSegment()
        currentSegment?.add(motions)
    }
    
    func setupSegmentSize(width: CGFloat = GraphNumber.segmentWidth, height: Double) {
        segmentWidth = width
        segmentHeight = height
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
                                  width: segmentWidth,
                                  height: segmentHeight)
        
        segments.append(newSegment)
        self.addSubview(newSegment)
    }
    
    private func removeOutofBoundsSegment() {
        segments.forEach { segment in
            if segment.frame.origin.x + segmentWidth >= bounds.size.width {
                segment.removeFromSuperview()
            }
        }
    }
}

// MARK: - setup UI
extension GraphView {
    private func setupView() {
        addSubView()
        segmentHeight = bounds.size.height
        self.layer.borderWidth = GraphNumber.borderWidth
        self.layer.borderColor = UIColor.black.cgColor
        self.backgroundColor = .systemBackground
    }
    
    private func addSubView() {
        dataStackView.addArrangedSubview(xDataLabel)
        dataStackView.addArrangedSubview(yDataLabel)
        dataStackView.addArrangedSubview(zDataLabel)
        
        self.addSubview(dataStackView)
        
        NSLayoutConstraint.activate([
            dataStackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor
                                               , constant: 8),
            dataStackView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor
                                               , constant: 16),
            dataStackView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor
                                               , constant: -16)
        ])
    }
    
    private func setupLabel(with data: [Double]) {
        xDataLabel.text = "x: " + refineData(data[MotionData.x.rawValue])
        yDataLabel.text = "y: " + refineData(data[MotionData.y.rawValue])
        zDataLabel.text = "z: " +  refineData(data[MotionData.z.rawValue])
    }
    
    private func refineData(_ data: Double) -> String {
        return String(format: "%.4f", data)
    }
}
