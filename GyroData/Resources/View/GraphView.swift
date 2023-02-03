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
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
}

// MARK: - UIConfiguration
private extension GraphView {
    func configureUI() {
        addChildView()
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
