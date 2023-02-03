//
//  RecordViewController.swift
//  GyroData
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit
import CoreMotion

final class RecordViewController: UIViewController {
    
    // MARK: - Property
    let segmentControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Acc", "Gyro"])
        control.selectedSegmentIndex = 0
        return control
    }()
    
    let indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        return indicator
    }()
    
    private let graphView: GraphView = {
        let graphView = GraphView(frame: .zero)
        graphView.backgroundColor = .systemBackground
        graphView.layer.borderWidth = 3
        return graphView
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
    
    private let motionManager = MotionManager()
    private var recordTime: Double = 0
    private var recordedSensor: SensorType = .Accelerometer
    private var values: [TransitionValue] = []
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        motionManager.delegate = self
        setButtonAction()
        
        convertButtonsState(isEnable: true)
    }
}

// MARK: - Motion Manager Delegate
extension RecordViewController: MotionManagerDelegate {
    func motionManager(send manager: MotionManager, sendData: CMLogItem?) {
        guard let data = sendData,
              let sensor = SensorType(rawInt: segmentControl.selectedSegmentIndex) else {
            return
        }
        
        graphView.callDrawLine(data, sensor)
        saveData(data: data)
    }
    
    func motionManager(stop manager: MotionManager, sendTime: Double) {
        self.recordTime = sendTime
    }
}

extension RecordViewController: Uploadable {
    func upload(completion: @escaping (Result<Void, UploadError>) -> Void) {
        var isSuccessJson: Bool = false
        var isSuccessCoreData: Bool = false
        let uploadGroup = DispatchGroup()
        
        let fileName = Date().fileName()
        
        let transitionValues = values.convertTransition()
        let metaData = TransitionMetaData(
            saveDate: Date().description,
            sensorType: recordedSensor,
            recordTime: recordTime,
            jsonName: fileName
        )
        
        uploadJson(dispatchGroup: uploadGroup, fileName: fileName, transition: transitionValues) { result in
            switch result {
            case .success(let isSuccess):
                isSuccessJson = isSuccess
            case .failure:
                isSuccessJson = false
            }
        }
        
        uploadCoreDataObject(dispatchGroup: uploadGroup, metaData: metaData) { result in
            switch result {
            case .success(let isSuccess):
                isSuccessCoreData = isSuccess
                
            case .failure:
                isSuccessCoreData = false
            }
        }
        
        uploadGroup.notify(queue: .main) {
            if isSuccessJson == false {
                completion(.failure(UploadError.jsonUploadFailed))
                return
            }
            
            if isSuccessCoreData == false {
                completion(.failure(UploadError.coreDataUploadFailed))
                return
            }
            
            if isSuccessJson && isSuccessCoreData {
                completion(.success(()))
                return
            }
        }
    }
}

// MARK: - Business Logic
private extension RecordViewController {
    func saveData(data: CMLogItem) {
        if let accelerometerData = data as? CMAccelerometerData {
            let valueSet = accelerometerData.acceleration
            values.append((valueSet.x, valueSet.y, valueSet.z))
        } else if let gyroData = data as? CMGyroData {
            let valueSet = gyroData.rotationRate
            values.append((valueSet.x, valueSet.y, valueSet.z))
        }
    }
}

// MARK: - ButtonMethod
private extension RecordViewController {
    func setButtonAction() {
        let saveButton = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(didTapSaveButton))
        navigationItem.rightBarButtonItem = saveButton
        
        recordButton.addTarget(self, action: #selector(didTapRecordButton), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
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
}

// MARK: - ObjcMethod
private extension RecordViewController {
    @objc func didTapRecordButton() {
        let segmentIndex = segmentControl.selectedSegmentIndex
        guard let sensor = SensorType(rawInt: segmentIndex) else { return }
        recordedSensor = sensor
        
        if !values.isEmpty {
            values.removeAll()
            recordTime = .zero
        }
        
        motionManager.startRecord(with: sensor)
        convertButtonsState(isEnable: false)
    }
    
    @objc func didTapCancelButton() {
        motionManager.stopRecord()
        convertButtonsState(isEnable: true)
    }
    
    @objc func didTapSaveButton() {
        indicator.startAnimating()
        
        upload { [weak self] result in
            guard let self = self else { return }
            
            self.indicator.stopAnimating()
            
            switch result {
            case .success:
                self.navigationController?.popViewController(animated: true)
            case .failure(let error):
                self.presentErrorAlert(error: error)
            }
        }
    }
}

private extension RecordViewController {
    func presentErrorAlert(error: UploadError) {
        let alert = AlertConcreteBuilder()
            .setTitle(to: error.alertTitle)
            .setMessage(to: error.alertMessage)
            .setButton(title: "확인", style: .default, completion: nil)
            .build()
        
        present(alert, animated: true)
    }
}

// MARK: - UIConfiguration
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
        [segmentControl, recordButton, cancelButton, graphView, indicator].forEach {
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
            
            graphView.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 20),
            graphView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            graphView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            graphView.heightAnchor.constraint(equalTo: graphView.widthAnchor),
            
            recordButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            recordButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            recordButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            recordButton.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -20),
            
            cancelButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            cancelButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            cancelButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            cancelButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -50),
            
            indicator.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor)
        ])
    }
}
