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
        
        segments.forEach {
            $0.removeFromSuperview()
        }
        
        segments.removeAll()
    }
    
    func add(_ motions: [Double]) {
        setupLabel(with: motions)
        
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

// MARK: - setup UI
extension GraphView {
    private func setupView() {
        addSubView()
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
