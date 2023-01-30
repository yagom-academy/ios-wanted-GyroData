//
//  MeasurementViewController.swift
//  GyroData
//
//  Created by 로빈 on 2023/01/30.
//

import UIKit

final class MeasurementViewController: UIViewController {
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
}
