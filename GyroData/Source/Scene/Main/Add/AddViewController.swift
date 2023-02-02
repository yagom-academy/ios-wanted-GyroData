//
//  AddViewController.swift
//  GyroData
//
//  Created by Baem, Dragon on 2023/01/31.
//

import UIKit
import CoreMotion

class AddViewController: UIViewController {
    // MARK: Enumerations
    
    enum MeasurementUnit: Int {
        case acc = 0
        case gyro = 1
    }
    
    // MARK: Private Properties
    
    private let currentDate = Date()
    private let motionManager = CMMotionManager()
    private var motionDataList = [MotionData]()
    private var jsonMotionData: Data?
    
    private let segmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: ["Acc", "Gyro"])
        segmentControl.backgroundColor = .white
        segmentControl.selectedSegmentIndex = 0
        return segmentControl
    }()
    private let graphView: GraphView = {
        let view = GraphView()
        view.backgroundColor = .systemBackground
        view.layer.borderWidth = 3
        view.layer.borderColor = UIColor.black.cgColor
        return view
    }()
    private let playButton: UIButton = {
        let button = UIButton()
        button.setTitle("측정", for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .title2)
        button.contentHorizontalAlignment = .left
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    private let stopButton: UIButton = {
        let button = UIButton()
        button.setTitle("정지", for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .title2)
        button.contentHorizontalAlignment = .left
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 30
        return stackView
    }()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureLayout()
        configureButtonAction()
    }
    
    // MARK: Private Methods
    
    private func configureButtonAction() {
        playButton.addTarget(self, action: #selector(startMeasurement), for: .touchDown)
        stopButton.addTarget(self, action: #selector(stopMeasurement), for: .touchDown)
    }
    
    private func configureView() {
        view.backgroundColor = .systemBackground
        
        navigationItem.title = "측정하기"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "저장",
            style: .plain,
            target: self,
            action: #selector(saveMotionData)
        )
    }
    
    private func setUpMainStackView() {
        mainStackView.addArrangedSubview(segmentControl)
        mainStackView.addArrangedSubview(graphView)
        mainStackView.addArrangedSubview(playButton)
        mainStackView.addArrangedSubview(stopButton)
    }
    
    private func configureLayout() {
        setUpMainStackView()
        
        view.addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            segmentControl.widthAnchor.constraint(equalToConstant: view.frame.size.width * 0.85),
            
            graphView.widthAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.widthAnchor,
                multiplier: 0.85
            ),
            graphView.heightAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.heightAnchor,
                multiplier: 0.4
            ),
            
            playButton.heightAnchor.constraint(equalToConstant: view.frame.size.height * 0.055),
            playButton.widthAnchor.constraint(equalToConstant: view.frame.size.width * 0.15),
            
            stopButton.widthAnchor.constraint(equalToConstant: view.frame.size.width * 0.15),
            
            mainStackView.widthAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.widthAnchor ,
                multiplier: 0.85
            ),
            mainStackView.heightAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.heightAnchor,
                multiplier: 0.7
            ),
            mainStackView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: view.frame.size.width * 0.06
            ),
            mainStackView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: view.frame.size.height * 0.03
            )
        ])
    }
    
    // MARK: Action Methods
    
    @objc private func saveMotionData() {
        jsonMotionData = try? JSONEncoder().encode(motionDataList)
        
        guard let jsonMotionData = jsonMotionData,
              let dataString = String(data: jsonMotionData, encoding: .utf8) else { return }
        
        if dataString != "[]" {
            var titleText = String()
            
            switch segmentControl.selectedSegmentIndex {
            case MeasurementUnit.acc.rawValue:
                titleText = "Acc"
            case MeasurementUnit.gyro.rawValue:
                titleText = "Gyro"
            default:
                break
            }
            
            let dataForm = MotionDataForm(
                title: titleText,
                date: currentDate,
                runningTime: Double(motionDataList.count) / 10,
                jsonData: dataString
            )
            
            saveCoreData(motion: dataForm)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func startMeasurement() {
        motionDataList = .init()
        jsonMotionData = .init()
        graphView.stopDrawLines()
        
        switch segmentControl.selectedSegmentIndex {
        case MeasurementUnit.acc.rawValue:
            motionManager.accelerometerUpdateInterval = 0.1
            motionManager.startAccelerometerUpdates(to: .main) { data, error in
                if error == nil {
                    if let accData = data {
                        self.measureMotion(type: .acc, data: accData)
                    }
                }
            }
        case MeasurementUnit.gyro.rawValue:
            motionManager.gyroUpdateInterval = 0.1
            motionManager.startGyroUpdates(to: .main) { data, error in
                if error == nil {
                    if let gyroData = data {
                        self.measureMotion(type: .gyro, data: gyroData)
                    }
                }
            }
        default:
            break
        }
    }
    
    private func measureMotion(type: MeasurementUnit, data: CMLogItem) {
        switch type {
        case .acc:
            guard let totalData = data as? CMAccelerometerData else { return }
            let recordData = MotionData(
                x: totalData.acceleration.x,
                y: totalData.acceleration.y,
                z: totalData.acceleration.z
            )
            
            motionDataList.append(recordData)
            graphView.motionDatas = recordData
        case .gyro:
            guard let totalData = data as? CMGyroData else { return }
            let recordData = MotionData(
                x: totalData.rotationRate.x,
                y: totalData.rotationRate.y,
                z: totalData.rotationRate.z
            )
            
            motionDataList.append(recordData)
            graphView.motionDatas = recordData
        }
    }
    
    @objc private func stopMeasurement() {
        motionManager.stopAccelerometerUpdates()
        motionManager.stopGyroUpdates()
        
        graphView.stopDrawLines()
    }
}

// MARK: - CoreDataProcessible

extension AddViewController: CoreDataProcessible {}
