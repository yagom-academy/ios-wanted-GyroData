//
//  RecordViewController.swift
//  GyroData
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit
import CoreMotion

final class RecordViewController: UIViewController {
    let segmentControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Acc", "Gyro"])
        control.selectedSegmentIndex = 0
        return control
    }()
    
    let recordButton: UIButton = {
        let button = UIButton()
        button.setTitle("측정", for: .normal)
        button.setTitleColor(.gray, for: .disabled)
        button.layer.backgroundColor = UIColor.systemBlue.cgColor
        button.layer.cornerRadius = 5
        return button
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("취소", for: .normal)
        button.layer.backgroundColor = UIColor.systemBlue.cgColor
        button.layer.cornerRadius = 5
        return button
    }()
    
    let monitor = CMMotionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setButtonAction()
        
        convertButtonsState(isEnable: true)
    }
}

// MARK: Core Motion Manager Method
private extension RecordViewController {
    func startMonitoringAccelerometer() {
        guard monitor.isAccelerometerAvailable else { return }
        
        monitor.startAccelerometerUpdates(to: .main) { data, error in
            print(data)
        }
    }
    
    func startMonitoringGyro() {
        guard monitor.isGyroAvailable else { return }
        
        monitor.startGyroUpdates(to: .main) { data, error in
            print(data)
        }
    }
}

private extension RecordViewController {
    func setButtonAction() {
        let saveButton = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(didTapSaveButton))
        navigationItem.rightBarButtonItem = saveButton
        
        recordButton.addTarget(self, action: #selector(didTapRecordButton), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
    }
    
    @objc func didTapRecordButton() {
        let segmentIndex = segmentControl.selectedSegmentIndex
        
        switch segmentIndex {
        case 0:
            startMonitoringAccelerometer()
        case 1:
            startMonitoringGyro()
        default:
            return
        }
        convertButtonsState(isEnable: false)
    }
    
    @objc func didTapCancelButton() {
        if monitor.isAccelerometerActive {
            monitor.stopAccelerometerUpdates()
            convertButtonsState(isEnable: true)
            return
        }
        
        if monitor.isGyroActive {
            monitor.stopGyroUpdates()
            convertButtonsState(isEnable: true)
            return
        }
    }
    
    func convertButtonsState(isEnable: Bool) {
        recordButton.isEnabled = isEnable
        cancelButton.isHidden = isEnable
        
        if recordButton.isEnabled {
            recordButton.layer.backgroundColor = UIColor.systemBlue.cgColor
        } else {
            recordButton.layer.backgroundColor = UIColor.systemGroupedBackground.cgColor
        }
    }
    
    @objc func didTapSaveButton() {
        // TODO: 저장 메서드 생성
    }
}

private extension RecordViewController {
    func configureUI() {
        setBackgroundColor()
        setNavigationBar()
        setAdditionalSafeArea()
        
        addChildView()
        setLayout()
    }

    func setNavigationBar() {
        navigationItem.title = "측정"
    }
    
    func setBackgroundColor() {
        view.backgroundColor = .systemBackground
    }
    
    func setAdditionalSafeArea() {
        let padding: CGFloat = 10
        
        additionalSafeAreaInsets.top += padding
        additionalSafeAreaInsets.bottom += padding
        additionalSafeAreaInsets.left += padding
        additionalSafeAreaInsets.right += padding
    }
    
    func addChildView() {
        [segmentControl, recordButton, cancelButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    func setLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            segmentControl.topAnchor.constraint(equalTo: safeArea.topAnchor),
            segmentControl.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            segmentControl.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            segmentControl.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            
            recordButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            recordButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            recordButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            recordButton.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -20),
            
            cancelButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            cancelButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            cancelButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            cancelButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -50)
        ])
    }
}
