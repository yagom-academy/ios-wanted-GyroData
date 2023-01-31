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
    
    let coreMotionManager = CoreMotionManager()
    var selectedSensor: SensorType?
    var values: [TransitionValue] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setButtonAction()
<<<<<<< HEAD
        coreMotionManager.delegate = self

=======
        
>>>>>>> parent of d70a65a (chore: ViewController -> TransitionListViewController 이름변경 및 RecordViewController와 컨벤션 통일)
        convertButtonsState(isEnable: true)
    }
}

extension RecordViewController: CoreMotionDelegate {
    func coreMotionManager(transitionData: CMLogItem) {
        if let data = transitionData as? CMAccelerometerData {
            let value = data.acceleration
            values.append((value.x, value.y, value.z))
        } else if let data = transitionData as? CMGyroData {
            let value = data.rotationRate
            values.append((value.x, value.y, value.z))
        }
    }
}

<<<<<<< HEAD
// MARK: - FileManagerLogic
private extension RecordViewController {
    func saveJsonData() {
        let transition = values.convertTransition()

        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        let documentDirectories = FileManager
            .default
            .urls(for: .documentDirectory, in: .userDomainMask)
        
        guard let encodeData = try? encoder.encode(transition),
              let documentDirectory = documentDirectories.first else {
            return
        }
        
        let pathWithFileName = documentDirectory.appendingPathComponent("\(Date().description).json")

        try? encodeData.write(to: pathWithFileName)
    }
}

// MARK: - ButtonMethod
=======
>>>>>>> parent of d70a65a (chore: ViewController -> TransitionListViewController 이름변경 및 RecordViewController와 컨벤션 통일)
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
            saveJsonData()
            return
        }
        
        if monitor.isGyroActive {
            monitor.stopGyroUpdates()
            convertButtonsState(isEnable: true)
            saveJsonData()
            return
        }
    }
    
    func saveJsonData() {
        let transition = values.convertTransition()
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        guard let encodeData = try? encoder.encode(transition) else {
            return
        }
        
        if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let pathWithFileName = documentDirectory.appendingPathComponent("\(Date().description).json")
            
            do {
                try encodeData.write(to: pathWithFileName)
            } catch {
                NSLog(error.localizedDescription)
            }
        }
    }
    
    func convertButtonsState(isEnable: Bool) {
        recordButton.isEnabled = isEnable
        cancelButton.isHidden = isEnable
        segmentControl.isEnabled = isEnable
        navigationItem.rightBarButtonItem?.isEnabled = isEnable
        
        if recordButton.isEnabled {
            recordButton.layer.backgroundColor = UIColor.systemBlue.cgColor
        } else {
            recordButton.layer.backgroundColor = UIColor.systemGroupedBackground.cgColor
        }
    }
    
<<<<<<< HEAD
    func resetTransitionValues() {
        if !values.isEmpty { values.removeAll() }
    }
}


// MARK: - ObjcMethod
private extension RecordViewController {
    @objc func didTapRecordButton() {
        let segmentIndex = segmentControl.selectedSegmentIndex
        guard let sensor = SensorType(rawInt: segmentIndex) else { return }
        selectedSensor = sensor
        
        resetTransitionValues()
        coreMotionManager.startUpdateData(with: sensor)
        convertButtonsState(isEnable: false)
    }

    @objc func didTapCancelButton() {
        coreMotionManager.cancelUpdateData()
        convertButtonsState(isEnable: true)
    }

=======
>>>>>>> parent of d70a65a (chore: ViewController -> TransitionListViewController 이름변경 및 RecordViewController와 컨벤션 통일)
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
