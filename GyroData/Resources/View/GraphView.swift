//
//  GraphView.swift
//  GyroData
//
//  Created by Mangdi on 2023/02/03.
//

import UIKit

class GraphView: UIView {

    // MARK: - Property
    private let xPositionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.text = "x:"
        return label
    }()

    private let yPositionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGreen
        label.text = "y:"
        return label
    }()

    private let zPositionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemBlue
        label.text = "z:"
        return label
    }()

    // MARK: - 뭐로하지..??
    override init(frame: CGRect) {
        super.init(frame: frame)

        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        makeGridBackground()
    }
}

// MARK: - GraphViewConfiguration
private extension GraphView {
    func makeGridBackground() {
        let gridLayer = CAShapeLayer()
        let gridPath = UIBezierPath()
        let divideCount = 8
        let xOffset = (self.frame.width - 20) / CGFloat(divideCount)
        let yOffset = (self.frame.height - 20) / CGFloat(divideCount)
        var currentX: CGFloat = 10
        var currentY: CGFloat = 10

        for index in 1...divideCount + 1 {
            gridPath.move(to: CGPoint(x: currentX, y: currentY))
            gridPath.addLine(to: CGPoint(x: self.frame.width - 10, y: currentY))
            currentY = 10 + CGFloat(index) * yOffset
        }

        currentY = 10

        for index in 1...divideCount + 1 {
            gridPath.move(to: CGPoint(x: currentX, y: currentY))
            gridPath.addLine(to: CGPoint(x: currentX, y: self.frame.height - 10))
            currentX = 10 + CGFloat(index) * xOffset
        }

        gridLayer.fillColor = nil
        gridLayer.strokeColor = UIColor.systemGray.cgColor
        gridLayer.lineWidth = 2
        gridLayer.path = gridPath.cgPath
        self.layer.addSublayer(gridLayer)
    }
}

// MARK: - UIConfiguration
private extension GraphView {
    func configureUI() {
        addChildView()
        setUpLayouts()
    }

    func addChildView() {
        [xPositionLabel, yPositionLabel, zPositionLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
    }

    func setUpLayouts() {
        NSLayoutConstraint.activate([
            xPositionLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            xPositionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),

            zPositionLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            zPositionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40),

            yPositionLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            yPositionLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        ])
    }
}
