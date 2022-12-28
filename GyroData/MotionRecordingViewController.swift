//
//  MotionRecordingViewController.swift
//  GyroData
//
//  Created by YunYoungseo on 2022/12/27.
//

import UIKit

final class MotionRecordingViewController: UIViewController {
    private lazy var motionRecordingViewModel = MotionRecordingViewModel(msInterval: msInterval, motionMode: .accelerometer, updateCompletion: drawGraphFor1Hz)
    private let msInterval = 100

    private let recordButton = {
        let button = UIButton(type: .system)
        button.setTitle("측정", for: .normal)
        return button
    }()

    private let stopButton = {
        let button = UIButton(type: .system)
        button.setTitle("정지", for: .normal)
        return button
    }()
    
    private lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl()

        MotionMode.allCases.enumerated().forEach { index, mode in
            segmentedControl.insertSegment(withTitle: mode.segmentName, at: index, animated: false)
        }
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()

    private let graphView: GraphView = {
        let graphView = GraphView()
        graphView.layer.borderWidth = 2
        graphView.layer.borderColor = UIColor.gray.cgColor
        graphView.translatesAutoresizingMaskIntoConstraints = false
        graphView.heightAnchor.constraint(equalTo: graphView.widthAnchor).isActive = true
        return graphView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        setButtonActions()
    }

    private func drawGraphFor1Hz(_ coordiante: Coordiante) {
        DispatchQueue.main.async { [weak self] in
            self?.graphView.drawGraphFor1Hz(layerType: .red, value: coordiante.x)
            self?.graphView.drawGraphFor1Hz(layerType: .green, value: coordiante.y)
            self?.graphView.drawGraphFor1Hz(layerType: .blue, value: coordiante.z)
        }
    }

    private func setButtonActions() {
        MotionMode.allCases.enumerated().forEach { index, mode in
            let segment = UIAction(title: mode.segmentName) { _ in
                self.motionRecordingViewModel.motionMode = mode
            }
            segmentedControl.setAction(segment, forSegmentAt: index)
        }
        let startRecording = UIAction() { [weak self] _ in
            self?.motionRecordingViewModel.startRecording()
        }
        let stopRecording = UIAction() { [weak self] _ in
            self?.motionRecordingViewModel.stopRecording()
        }
        recordButton.addAction(startRecording, for: .touchUpInside)
        stopButton.addAction(stopRecording, for: .touchUpInside)
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
