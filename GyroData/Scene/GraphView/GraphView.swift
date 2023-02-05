//
//  GraphView.swift
//  GyroData
//
//  Created by Wonbi on 2023/02/05.
//

import UIKit

final class GraphView: UIView {
    static let segmentColor: [UIColor] = [.systemRed, .systemGreen, .systemBlue]
    
    private let xLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption2)
        label.textAlignment = .center
        label.textColor = segmentColor[0]
        label.text  = "x: 123123"
        return label
    }()
    
    private let yLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption2)
        label.textAlignment = .center
        label.textColor = segmentColor[1]
        label.text  = "x: 123123"
        return label
    }()
    
    private let zLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption2)
        label.textAlignment = .center
        label.textColor = segmentColor[2]
        label.text  = "x: 123123"
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
    
    private var gridHeight: CGFloat {
        return bounds.height / 8
    }
    
    private var gridWidth: CGFloat {
        return bounds.width / 8
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setStrokeColor(UIColor.systemGray4.cgColor)
        
        for lineIndex in 1...7 {
            // 세로줄
            context.move(to: CGPoint(x: gridWidth * CGFloat(lineIndex), y: 0))
            context.addLine(to: CGPoint(x: gridWidth * CGFloat(lineIndex), y: bounds.height))
            // 가로줄
            context.move(to: CGPoint(x: 0, y: gridHeight * CGFloat(lineIndex)))
            context.addLine(to: CGPoint(x: bounds.width, y: gridHeight * CGFloat(lineIndex)))
        }
        
        context.strokePath()
    }
    
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
