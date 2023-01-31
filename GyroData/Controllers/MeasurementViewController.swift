//
//  MeasurementViewController.swift
//  GyroData
//
//  Created by 로빈 on 2023/01/30.
//

import UIKit

final class MeasurementViewController: UIViewController {
    // MARK: View Properties
    private lazy var segmentedController: UISegmentedControl = {
        let controller = UISegmentedControl(items: ["Acc", "Gyro"])
        controller.translatesAutoresizingMaskIntoConstraints = false
        controller.addTarget(self, action: #selector(changeSensor(sender:)), for: .valueChanged)
        controller.selectedSegmentIndex = 0
        controller.selectedSegmentTintColor = .systemBlue
        return controller
    }()

    private let graph: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemYellow
        return view
    }()

    private lazy var saveBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "저장", primaryAction: makeSaveButtonAction())
        return button
    }()

    private lazy var measurementButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("측정", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addAction(makeMeasurementButtonAction(), for: .touchUpInside)
        return button
    }()

    private lazy var stopButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("정지", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addAction(makeStopButtonAction(), for: .touchUpInside)
        return button
    }()

    // MARK: Properties
    private let measurementManager = MeasurementManager()
    private var selectedSensor: Sensor {
        guard let selectedSensor = Sensor(rawValue: segmentedController.selectedSegmentIndex) else { fatalError() }
        return selectedSensor
    }

    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        configureView()
        configureConstraints()
    }

    // MARK: NavigationBar
    private func configureNavigationBar() {
        navigationItem.title = "측정하기"
        navigationItem.rightBarButtonItem = saveBarButton
    }

    // MARK: configure View
    private func configureView() {
        view.addSubview(measurementButton)
        view.addSubview(stopButton)
        view.addSubview(segmentedController)
        view.addSubview(graph)
    }

    private func configureConstraints() {
        NSLayoutConstraint.activate([
            segmentedController.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            segmentedController.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            segmentedController.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),

            graph.topAnchor.constraint(equalTo: segmentedController.bottomAnchor, constant: 16),
            graph.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            graph.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            graph.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),

            measurementButton.topAnchor.constraint(equalTo: graph.bottomAnchor, constant: 16),
            measurementButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),

            stopButton.topAnchor.constraint(equalTo: measurementButton.bottomAnchor, constant: 16),
            stopButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
        ])
    }

    // MARK: Actions
    @objc private func changeSensor(sender: UISegmentedControl) {
        print("선택:\(selectedSensor)")
    }

    private func makeSaveButtonAction() -> UIAction {
        let action = UIAction { [weak self] _ in
            self?.saveSensorData()
        }

        return action
    }

    private func makeMeasurementButtonAction() -> UIAction {
        let action = UIAction { [weak self] _ in
            self?.measure()
        }

        return action
    }

    private func makeStopButtonAction() -> UIAction {
        let action = UIAction { [weak self] _ in
            self?.measureStop()
        }

        return action
    }

    // MARK: Methods
    private func measure() {
        measurementManager.measure(sensor: selectedSensor)
    }

    private func measureStop() {
        measurementManager.stop(sensor: selectedSensor)
    }

    private func saveSensorData() {
        fatalError()
    }

    private func setDisabledSegments() {
        for segmentIndex in 0..<numberOfSegments {
            // 선택되지 않은 세그먼트 제외 모두 비활성화
            if !(segmentedController.selectedSegmentIndex == segmentIndex) {
                segmentedController.setEnabled(false, forSegmentAt: segmentIndex)
            }
        }
    }

    private func setEnabledSegments() {
        for segmentIndex in 0..<numberOfSegments {
            // 비활성화된 세그먼트 활성화
            if !segmentedController.isEnabledForSegment(at: segmentIndex) {
                segmentedController.setEnabled(true, forSegmentAt: segmentIndex)
            }
        }
    }
}
