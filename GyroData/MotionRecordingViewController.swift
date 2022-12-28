//
//  MotionRecordingViewController.swift
//  GyroData
//
//  Created by YunYoungseo on 2022/12/27.
//

import UIKit

final class MotionRecordingViewController: UIViewController {

    private let segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl()
        MotionMode.allCases.enumerated().forEach { index, mode in
            segmentedControl.insertSegment(withTitle: mode.segmentName, at: index, animated: false)
        }
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()

    private let graphView: GraphView = {
        let graphView = GraphView()
        graphView.layer.borderWidth = 1
        graphView.layer.borderColor = UIColor.gray.cgColor
        graphView.translatesAutoresizingMaskIntoConstraints = false
        graphView.heightAnchor.constraint(equalTo: graphView.widthAnchor).isActive = true
        return graphView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
    }

    private func layout() {
        view.backgroundColor = .systemBackground
        let spacing = 20.0

        navigationItem.title = "측정하기"
        let saveButton = UIBarButtonItem(title: "저장", style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = saveButton

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

        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: spacing),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -spacing),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        ])
    }
}

private extension MotionMode {
    var segmentName: String {
        switch self {
        case .accelerometer:
            return "Acc"
        case .gyroscope:
            return "Gyro"
        }
    }
}
