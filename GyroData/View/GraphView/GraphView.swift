//
//  GraphView.swift
//  GyroData
//
//  Created by ash and som on 2023/01/31.
//

import UIKit

final class GraphView: UIView {
    let xLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .systemRed
        label.font = .preferredFont(forTextStyle: .body)
        return label
    }()
    
    let yLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .systemBlue
        label.font = .preferredFont(forTextStyle: .body)
        return label
    }()
    
    let zLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .systemGreen
        label.font = .preferredFont(forTextStyle: .body)
        return label
    }()
    
    let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        return stackView
    }()

    private var segmentWidth = GraphContent.segmentWidth
    private var segments = [GraphSegment]()
    private var currentSegment: GraphSegment? {
        return segments.last
    }

    var segmentData: [[Double]] {
        return segments.map {
            $0.dataPoint
        }
    }

    var valueRanges = [-4.0...4.0, -4.0...4.0, -4.0...4.0]

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureLayout() {
        addSubview(labelStackView)

        labelStackView.addArrangedSubview(xLabel)
        labelStackView.addArrangedSubview(yLabel)
        labelStackView.addArrangedSubview(zLabel)
        
        NSLayoutConstraint.activate([
            labelStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8),
            labelStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            labelStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }

        context.drawGraphLines(in: bounds.size)
    }

    func add(_ motions: [Double]) {
        configureLabel(with: motions)

        for segment in segments {
            segment.center.x += 1
        }

        purgeSegments()
        addSegment()
        currentSegment?.add(motions)
    }

    func clear() {
        configureLabel(with: [.zero, .zero, .zero])
        segments.removeAll()
    }

    private func configureLabel(with data: [Double]) {
        xLabel.text = "x: " + transformData(data[CoordinateData.x.rawValue])
        yLabel.text = "y: " + transformData(data[CoordinateData.y.rawValue])
        zLabel.text = "z: " + transformData(data[CoordinateData.z.rawValue])

    }

    private func addSegment() {
        let startPoint: [Double]
        if let currentSegment = currentSegment {
            guard currentSegment.dataPoint.isEmpty == false else { return }
            startPoint = currentSegment.dataPoint
        } else {
            startPoint = [.zero, .zero, .zero]
        }

        let segment = GraphSegment(startPoint: startPoint, segmentWidth: segmentWidth)
        segment.backgroundColor = .clear
        segment.frame = CGRect(x: .zero,
                               y: .zero,
                               width: segmentWidth,
                               height: bounds.size.height)

        segments.append(segment)
        addSubview(segment)
    }

    private func purgeSegments() {
        segments.forEach { segment in
            if segment.frame.origin.x + segmentWidth >= bounds.size.width {
                segment.removeFromSuperview()
            }
        }
    }

    private func transformData(_ data: Double) -> String {
        return String(format: "%.4f", data)
    }
}
