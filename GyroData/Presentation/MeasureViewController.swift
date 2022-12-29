//
//  MeasureViewController.swift
//  GyroData
//
//  Created by bonf, seohyeon2 on 2022/12/26.
//

import UIKit

class MeasureViewController: UIViewController {
    private let measureView = MeasureView()
    private let measurementService = MeasurementService()
    private let coreDataManager = CoreDataManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
        setupNavigationItem()
        setupDefault()
    }
    
    private func setupButton() {
        let measureAction = UIAction { [weak self] _ in
            Stopwatch.share.isRunning = true
            self?.measureView.stopButton.isHidden = false
            self?.toggleSegmentedControl(isEnable: false)
            
            switch self?.measureView.measurementSegmentedControl.selectedSegmentIndex {
            case MeasurementType.acc.number:
                self?.measurementService.measureAccelerometer()
            default:
                self?.measurementService.measureGyro()
            }
            
            self?.navigationItem.rightBarButtonItem = nil
        }
        
        let stopAction = UIAction { [weak self] _ in
            self?.measurementService.stopMeasurement()
            self?.toggleSegmentedControl(isEnable: true)
            self?.navigationItem.rightBarButtonItem = UIBarButtonItem(
                title: "저장",
                style: .done,
                target: self,
                action: #selector(self?.saveAction)
            )
            self?.measureView.stopButton.isHidden = true
        }
        
        measureView.measurementButton.addAction(measureAction, for: .touchUpInside)
        measureView.stopButton.addAction(stopAction, for: .touchUpInside)
    }
    
    private func toggleSegmentedControl(isEnable: Bool) {
        let index = measureView.measurementSegmentedControl.selectedSegmentIndex
        var number = MeasurementType.acc.number
        
        if index == MeasurementType.acc.number {
            number = MeasurementType.gyro.number
        }

        measureView.measurementSegmentedControl.setEnabled(isEnable, forSegmentAt: number)
    }
    
    private func setupNavigationItem() {
        self.navigationItem.title = "측정하기"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "저장",
            style: .done,
            target: self,
            action: #selector(saveAction)
        )
    }
    
    private func setupDefault() {
        view = measureView
        view.backgroundColor = .white
    }
    
    private func showFailureAlert(message: String) {
        let alert = UIAlertController(title: "저장 실패", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default)
        alert.addAction(okAction)
        
        self.present(alert, animated: true)
    }
    
    @objc
    private func stopAction() {
        measurementService.stopMeasurement()
        setupNavigationItem()
    }
    
    @objc
    private func saveAction() {
        if self.measurementService.timer.isValid {
            return
        }
        
        let data = self.measurementService.getMeasurementResult()
        
        if data.isEmpty {
            showFailureAlert(message: "데이터가 존재하지 않습니다.")
            return
        }

        var type = MeasurementType.acc.name
        if measureView.measurementSegmentedControl.selectedSegmentIndex == 1 {
            type = MeasurementType.gyro.name
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"

        let motion = Motion(
            date: dateFormatter.string(from: Date()),
            measurementType: type,
            motionX: data[0],
            motionY: data[1],
            motionZ: data[2]
        )
        
        measureView.indicator.center = view.center
        measureView.indicator.startAnimating()

        coreDataManager.save(data: motion) { result in
            self.measureView.indicator.stopAnimating()

            switch result {
            case .success:
                self.navigationController?.popViewController(animated: true)
            case .failure(let error):
                self.showFailureAlert(message: error.localizedDescription)
            }
        }
    }
}
