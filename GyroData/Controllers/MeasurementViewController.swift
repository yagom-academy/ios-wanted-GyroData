//
//  MeasurementViewController.swift
//  GyroData
//
//  Created by 로빈 on 2023/01/30.
//

import UIKit

final class MeasurementViewController: UIViewController {
    private lazy var segmentedController: UISegmentedControl = {
        let controller = UISegmentedControl(items: ["Acc", "Gyro"])
        controller.translatesAutoresizingMaskIntoConstraints = false
        controller.addTarget(self, action: #selector(changeSensor(sender:)), for: .valueChanged)
        controller.selectedSegmentIndex = 0
        controller.selectedSegmentTintColor = .systemBlue
        return controller
    }()

    private var selectedSensor: Sensor {
        guard let selectedSensor = Sensor(rawValue: segmentedController.selectedSegmentIndex) else { fatalError() }
        return selectedSensor
    }
    
    private lazy var saveBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "저장", primaryAction: makeSaveButtonAction())
        return button
    }()

    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
    }

    private func makeSaveButtonAction() -> UIAction {
        let action = UIAction { [weak self] _ in
            self?.saveSensorData()
        }

        return action
    }

    private func configureNavigationBar() {
        navigationItem.title = "측정하기"
        navigationItem.rightBarButtonItem = saveBarButton
    }

    private func saveSensorData() {
        fatalError()
    }

    @objc private func changeSensor(sender: UISegmentedControl) {
        print("선택:\(selectedSensor)")
    }
}
