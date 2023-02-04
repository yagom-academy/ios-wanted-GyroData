//
//  RecordViewController.swift
//  GyroData
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit
import CoreMotion

final class RecordViewController: UIViewController {

    // MARK: - Constant
    enum Constant {
        static let middleSpacing: CGFloat = 20
        static let largeSpacing: CGFloat = 50
    }
    
    // MARK: - Property
    private let segmentControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Acc", "Gyro"])
        control.selectedSegmentIndex = 0
        return control
    }()
    
    private let indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        return indicator
    }()
    
    private let graphView: GraphView = {
        let graphView = GraphView(frame: .zero)
        graphView.backgroundColor = .systemBackground
        return graphView
    }()
    
    private let recordButton: UIButton = {
        let button = UIButton()
        button.setTitle("측정", for: .normal)
        button.setTitleColor(.gray, for: .disabled)
        button.layer.backgroundColor = UIColor.systemBlue.cgColor
        button.layer.cornerRadius = 5
        return button
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("정지", for: .normal)
        button.layer.backgroundColor = UIColor.systemBlue.cgColor
        button.layer.cornerRadius = 5
        return button
    }()
    
    private let motionManager = MotionManager()
    private var recordTime: Double = 0
    private var recordedSensor: SensorType = .Accelerometer
    private var values: [Tick] = []
    private var isRestart: Bool = false
    
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
        guard let data = sendData else { return }
        saveData(data: data)
    }
    
    func motionManager(stop manager: MotionManager, sendTime: Double) {
        self.recordTime = sendTime
        isRestart = true
    }
}

// MARK: - Uploadable Method
extension RecordViewController: Uploadable {
    func upload(completion: @escaping (Result<Void, UploadError>) -> Void) {
        var isSuccessJson: Bool = false
        var isSuccessCoreData: Bool = false
        let uploadGroup = DispatchGroup()
        
        let fileName = Date().fileName()
        
        let transitionValues = Transition(values: values)
        let metaData = TransitionMetaData(
            saveDate: Date().saveDescription,
            sensorType: recordedSensor,
            recordTime: recordTime,
            jsonName: fileName
        )
        
        uploadJson(dispatchGroup: uploadGroup, fileName: fileName, transition: transitionValues) { result in
            switch result {
            case .success:
                isSuccessJson = true
            case .failure:
                isSuccessJson = false
            }
        }
        
        uploadCoreDataObject(dispatchGroup: uploadGroup, metaData: metaData) { result in
            switch result {
            case .success:
                isSuccessCoreData = true
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
            let tick = Tick(x: valueSet.x, y: valueSet.y, z: valueSet.z)
            drawGraphView(tick: tick)
            values.append(tick)
        } else if let gyroData = data as? CMGyroData {
            let valueSet = gyroData.rotationRate
            let tick = Tick(x: valueSet.x, y: valueSet.y, z: valueSet.z)
            drawGraphView(tick: tick)
            values.append(tick)
        }
    }
    
    func drawGraphView(tick: Tick) {
        if isRestart {
            graphView.settingInitialization()
            values.removeAll()
            isRestart = false
        }
        
        graphView.drawRecord(with: .Accelerometer, values: tick, isStart: values.isEmpty)
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
        segmentControl.isEnabled = isEnable
        navigationItem.rightBarButtonItem?.isEnabled = isEnable
        
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

//
// MARK 필요!!
//
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
            
            graphView.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: Constant.middleSpacing),
            graphView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constant.middleSpacing),
            graphView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constant.middleSpacing),
            graphView.heightAnchor.constraint(equalTo: graphView.widthAnchor),
            
            recordButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            recordButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            recordButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            recordButton.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -Constant.middleSpacing),
            
            cancelButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            cancelButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            cancelButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            cancelButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -Constant.largeSpacing),
            
            indicator.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor)
        ])
        
    }
}
