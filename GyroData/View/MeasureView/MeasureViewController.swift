//
//  MeasureViewController.swift
//  GyroData
//
//  Created by 이원빈 on 2022/12/29.
//

import UIKit

final class MeasureViewController: UIViewController {
    private let measureViewModel = MeasureViewModel()
    private let measureView = MeasureView()
    
    private var sensor: Sensor = Sensor.accelerometer
    private var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = measureView
        setupNavigationBar()
        setupButtons()
    }
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            sensor = Sensor.accelerometer
        case 1:
            sensor = Sensor.gyro
        default:
            return
        }
    }
    
    @objc func saveButtonDidTapped() {
        DefaultAlertBuilder(title: "알림", message: "저장 하시겠습니까?", preferredStyle: .alert)
            .setButton(name: "예", style: .default) {
                self.measureViewModel.saveCoreMotion()
                self.navigationItem.rightBarButtonItem?.isEnabled = false
            }
            .setButton(name: "아니오", style: .destructive, nil)
            .showAlert(on: self)
    }
    
    @objc func startButtonDidTapped() {
        measureViewModel.startCoreMotion(of: sensor)
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            self.measureView.setupMode(with: self.measureViewModel)
        }
    }
    
    @objc func stopButtonDidTapped() {
        measureViewModel.stopCoreMotion()
        timer?.invalidate()
        self.navigationItem.rightBarButtonItem?.isEnabled = true
    }
}

private extension MeasureViewController {
    
    func setupNavigationBar() {
        let rightButton: UIBarButtonItem = {
            let button = UIBarButtonItem(
                title: "저장",
                style: .plain,
                target: self,
                action: #selector(saveButtonDidTapped)
            )
            
            return button
        }()
        self.navigationItem.title = "측정하기"
        self.navigationItem.rightBarButtonItem = rightButton
        self.navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    func setupButtons() {
        measureView.segmentControl.addTarget(
            self,
            action: #selector(segmentedControlValueChanged),
            for: .valueChanged
        )
        measureView.startButton.addTarget(
            self,
            action: #selector(startButtonDidTapped),
            for: .touchUpInside
        )
        measureView.stopButton.addTarget(
            self,
            action: #selector(stopButtonDidTapped),
            for: .touchUpInside
        )
    }
}

