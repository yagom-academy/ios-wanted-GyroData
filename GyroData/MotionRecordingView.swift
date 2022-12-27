//
//  MotionRecordingViewController.swift
//  GyroData
//
//  Created by YunYoungseo on 2022/12/27.
//

import UIKit

final class MotionRecordingView: UIView {
    
    private let segmentedControl = {
        let segmentedControl = UISegmentedControl()
        MotionMode.allCases.enumerated().forEach { index, value in
            segmentedControl.insertSegment(withTitle: value.rawValue, at: index, animated: false)
        }
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()

    private let graphView = {
        let graphView = GraphView()
        graphView.layer.borderWidth = 1
        graphView.layer.borderColor = UIColor.gray.cgColor
        graphView.translatesAutoresizingMaskIntoConstraints = false
        graphView.heightAnchor.constraint(equalTo: graphView.widthAnchor).isActive = true
        return graphView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }

    private func layout() {
        let initialView = initializeStackView()
        addSubview(initialView)
        initialView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            initialView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            initialView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            initialView.topAnchor.constraint(equalTo: topAnchor),
        ])
    }

    private func initializeStackView() -> UIStackView {
        let spacing = 20.0

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = spacing

        let recordButton = UIButton(type: .system)
        recordButton.setTitle("측정", for: .normal)
        let stopButton = UIButton(type: .system)
        stopButton.setTitle("정지", for: .normal)

        let buttonStackView = UIStackView()
        buttonStackView.axis = .vertical
        buttonStackView.alignment = .leading
        buttonStackView.spacing = spacing

        stackView.addArrangedSubview(segmentedControl)
        stackView.addArrangedSubview(graphView)
        buttonStackView.addArrangedSubview(recordButton)
        buttonStackView.addArrangedSubview(stopButton)
        stackView.addArrangedSubview(buttonStackView)
        return stackView
    }
}

extension MotionRecordingView {
    private enum MotionMode: String, CaseIterable {
        case accelerometer = "Acc"
        case gyroscope = "Gyro"
    }
}
