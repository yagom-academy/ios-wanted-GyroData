//
//  GraphView.swift
//  GyroData
//
//  Created by Wonbi on 2023/02/05.
//

import UIKit

final class GraphView: UIView {
    enum Default {
        static let rangeLimit: Double = 1.0
        static let xLabel: String = "x: 0.0000"
        static let yLabel: String = "y: 0.0000"
        static let zLabel: String = "z: 0.0000"
    }
    
    static let segmentColor: [UIColor] = [.systemRed, .systemGreen, .systemBlue]
    static let capacity: Double = 600.0
    
    private var segments: [GraphSegmentView] = []
    private var segmentWidth: CGFloat {
        return bounds.width / (GraphView.capacity / GraphSegmentView.capacity)
    }
    private var gridHeight: CGFloat {
        return bounds.height / 8
    }
    private var gridWidth: CGFloat {
        return bounds.width / 8
    }
    private(set) var rangeLimit: Double = Default.rangeLimit {
        didSet {
            changeSegmentsScale()
        }
    }
    private var scale: Double {
        return bounds.height / (rangeLimit * 2)
    }
    var motionData: [MotionDataType] {
        return segments.reduce(into: [MotionDataType]()) { $0 += $1.dataPoints }
    }
    
    private let xLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption2)
        label.textAlignment = .center
        label.text = Default.xLabel
        label.textColor = segmentColor[0]
        return label
    }()
    
    private let yLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption2)
        label.textAlignment = .center
        label.text = Default.yLabel
        label.textColor = segmentColor[1]
        return label
    }()
    
    private let zLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption2)
        label.textAlignment = .center
        label.text = Default.zLabel
        label.textColor = segmentColor[2]
        return label
    }()
    
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray4.cgColor
        backgroundColor = .systemBackground
        
        configureView()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setStrokeColor(UIColor.systemGray4.cgColor)
        
        for lineIndex in 1...7 {
            context.move(to: CGPoint(x: gridWidth * CGFloat(lineIndex), y: 0))
            context.addLine(to: CGPoint(x: gridWidth * CGFloat(lineIndex), y: bounds.height))
            
            context.move(to: CGPoint(x: 0, y: gridHeight * CGFloat(lineIndex)))
            context.addLine(to: CGPoint(x: bounds.width, y: gridHeight * CGFloat(lineIndex)))
        }
        
        context.strokePath()
    }
    
    func addData(_ data: MotionDataType) {
        if let maxData = [abs(data.x), abs(data.y), abs(data.z)].max(), maxData >= rangeLimit {
            rangeLimit = maxData + (maxData * 0.2)
        }
        
        if segments.isEmpty {
            addSegment()
        } else if let currentSegment = segments.last, currentSegment.isFull {
            addSegment()
        }
        
        segments.last?.addData(data)
        xLabel.text = "x: \(data.xDescription)"
        yLabel.text = "y: \(data.yDescription)"
        zLabel.text = "z: \(data.zDescription)"
    }
    
    func clear() {
        segments.removeAll()
        xLabel.text = Default.xLabel
        yLabel.text = Default.yLabel
        zLabel.text = Default.zLabel
        subviews.filter({ $0 is GraphSegmentView }).forEach { $0.removeFromSuperview() }
        rangeLimit = Default.rangeLimit
    }
    
    private func changeSegmentsScale() {
        segments.forEach { $0.setScale(to: scale) }
    }
    
    private func addSegment() {
        let segment: GraphSegmentView

        if let startPoint = segments.last?.dataPoints.last {
            segment = GraphSegmentView(
                frame: CGRect(
                    x: segmentWidth * Double(segments.count),
                    y: 0,
                    width: segmentWidth,
                    height: bounds.height
                ),
                scale: scale,
                startPoint: startPoint
            )
        } else {
            segment = GraphSegmentView(
                frame: CGRect(
                    x: 0,
                    y: 0,
                    width: segmentWidth,
                    height: bounds.height
                ),
                scale: scale
            )
        }
        
        segments.append(segment)
        addSubview(segment)
        bringSubviewToFront(labelStackView)
    }
}

// MARK: UI Componenets
extension GraphView {
    private func configureView() {
        [xLabel, yLabel, zLabel].forEach(labelStackView.addArrangedSubview(_:))
        
        addSubview(labelStackView)
    }
    
    private func configureLayout() {
        NSLayoutConstraint.activate([
            labelStackView.topAnchor.constraint(equalTo: topAnchor),
            labelStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            labelStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            labelStackView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.125)
        ])
    }
}
