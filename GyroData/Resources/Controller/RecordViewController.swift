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

    private let graphView: UIView = {
        let graphView = UIView()
        graphView.backgroundColor = .systemBackground
        graphView.layer.borderWidth = 3
        return graphView
    }()

    private let xPositionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.text = "x:"
        return label
    }()

    private let yPositionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGreen
        label.text = "y:"
        return label
    }()

    private let zPositionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemBlue
        label.text = "z:"
        return label
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

extension RecordViewController: MotionManagerDelegate {
    func motionManager(send manager: MotionManager, sendData: CMLogItem?) {
        guard let data = sendData else { return }
        print(data)
        saveData(data: data)
    }
    
    func motionManager(stop manager: MotionManager, sendTime: Double) {
        self.recordTime = sendTime
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
        let transitionData = values.convertTransition()
        guard let filePath = SystemFileManager.createFilePath() else { return }
        
        DispatchQueue.global().async {
            let _ = SystemFileManager().saveData(path: filePath, value: transitionData)
            
            // TODO: - Handle Error
        }
        
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            
            let transitionMeta = TransitionMetaData(
                saveDate: Date().description,
                sensorType: self.recordedSensor,
                recordTime: self.recordTime,
                jsonName: filePath.absoluteString
            )
            
            PersistentContainerManager.shared.createNewGyroObject(metaData: transitionMeta)
        }
    }
}

// MARK: - GraphViewConfiguration
private extension RecordViewController {
    func makeGridBackground() {
        graphView.layoutIfNeeded()
        let gridLayer = CAShapeLayer()
        let gridPath = UIBezierPath()
        let divideCount = 8
        let xOffset = (graphView.frame.width - 20) / CGFloat(divideCount)
        let yOffset = (graphView.frame.height - 20) / CGFloat(divideCount)
        var currentX: CGFloat = 10
        var currentY: CGFloat = 10

        for index in 1...divideCount + 1 {
            gridPath.move(to: CGPoint(x: currentX, y: currentY))
            gridPath.addLine(to: CGPoint(x: graphView.frame.width - 10, y: currentY))
            currentY = 10 + CGFloat(index) * yOffset
        }

        currentY = 10

        for index in 1...divideCount + 1 {
            gridPath.move(to: CGPoint(x: currentX, y: currentY))
            gridPath.addLine(to: CGPoint(x: currentX, y: graphView.frame.height - 10))
            currentX = 10 + CGFloat(index) * xOffset
        }

        gridLayer.fillColor = nil
        gridLayer.strokeColor = UIColor.systemGray.cgColor
        gridLayer.lineWidth = 2
        gridLayer.path = gridPath.cgPath
        graphView.layer.addSublayer(gridLayer)
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
        makeGridBackground()
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
        [segmentControl, recordButton, cancelButton, graphView, xPositionLabel, yPositionLabel, zPositionLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        [xPositionLabel, yPositionLabel, zPositionLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            graphView.addSubview($0)
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

            xPositionLabel.topAnchor.constraint(equalTo: graphView.topAnchor, constant: 20),
            xPositionLabel.leadingAnchor.constraint(equalTo: graphView.leadingAnchor, constant: 40),

            zPositionLabel.topAnchor.constraint(equalTo: graphView.topAnchor, constant: 20),
            zPositionLabel.trailingAnchor.constraint(equalTo: graphView.trailingAnchor, constant: -40),

            yPositionLabel.topAnchor.constraint(equalTo: graphView.topAnchor, constant: 20),
            yPositionLabel.centerXAnchor.constraint(equalTo: graphView.centerXAnchor)
        ])
    }
}
