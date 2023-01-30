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
    }

    // MARK: NavigationBar
    private func configureNavigationBar() {
        navigationItem.title = "측정하기"
        navigationItem.rightBarButtonItem = saveBarButton
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
}
