//
//  AddViewController.swift
//  GyroData
//
//  Created by Baem, Dragon on 2023/01/31.
//

import UIKit
import CoreMotion

final class AddViewController: UIViewController {
    
    // MARK: Enumerations
    
    private enum MeasurementUnit: Int {
        case acc
        case gyro
    }
    
    // MARK: Private Properties
    
    private let currentDate = Date()
    private let motionManager = CMMotionManager()
    private let graphView = GraphView()
    private var motionDataList = [MotionData]()
    private var jsonMotionData: Data?
    private var timer: Timer?
    private var measureTime: Int = 0
    
    private let segmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: [NameSpace.acc, NameSpace.gyro])
        segmentControl.backgroundColor = .white
        segmentControl.selectedSegmentIndex = 0
        return segmentControl
    }()
    private let playButton: UIButton = {
        let button = UIButton()
        button.setTitle(NameSpace.playButtonTitle, for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .title2)
        button.contentHorizontalAlignment = .left
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    private let stopButton: UIButton = {
        let button = UIButton()
        button.setTitle(NameSpace.stopButtonTitle, for: .normal)
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
    private let indicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.style = .medium
        activityIndicatorView.stopAnimating()
        return activityIndicatorView
    }()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureLayout()
        configureButtonAction()
    }
    
    // MARK: Private Methods
    
    private func configureView() {
        view.backgroundColor = .systemBackground
        
        navigationItem.title = NameSpace.navigationItemTitle
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: NameSpace.navigationItemRightButtonTitle,
            style: .plain,
            target: self,
            action: #selector(saveMotionData)
        )
    }
    
    private func configureButtonAction() {
        playButton.addTarget(self, action: #selector(startMeasurement), for: .touchDown)
        stopButton.addTarget(self, action: #selector(stopMeasurement), for: .touchDown)
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
    
    private func saveData() {
        jsonMotionData = try? JSONEncoder().encode(motionDataList)
        
        guard let jsonMotionData = jsonMotionData,
              let dataString = String(data: jsonMotionData, encoding: .utf8) else { return }
        
        if dataString != "[]" {
            var titleText = String()
            
            switch segmentControl.selectedSegmentIndex {
            case MeasurementUnit.acc.rawValue:
                titleText = NameSpace.acc
            case MeasurementUnit.gyro.rawValue:
                titleText = NameSpace.gyro
            default:
                break
            }
            
            let dataForm = MotionDataForm(
                title: titleText,
                date: currentDate,
                runningTime: Double(measureTime) / 10,
                jsonData: dataString
            )
            
            DispatchQueue.main.async {
                self.saveCoreData(motion: dataForm) {
                    self.indicatorView.stopAnimating()
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    private func startTimer() {
        stopTimer()
        measureTime = .init()

        timer = Timer.scheduledTimer(
            timeInterval: TimeInterval(0.1),
            target: self,
            selector: #selector(timerCallback),
            userInfo: nil,
            repeats: true
        )
    }
    
    private func stopTimer() {
        if timer != nil && timer?.isValid != nil {
            timer?.invalidate()
        }
    }
    
    private func presentSaveErrorAlert() {
        let alert = createAlert(
            title: NameSpace.alertTitle,
            message: NameSpace.alertMessage
        )
        let firstAlertAction = createAlertAction(
            title: NameSpace.firstAlertActionTitle
        ) {
            self.navigationController?.popViewController(animated: true)
        }
        let secondAlertAction = createAlertAction(
            title: NameSpace.secondAlertActionTitle
        ) {}
        
        alert.addAction(firstAlertAction)
        alert.addAction(secondAlertAction)
        
        present(alert, animated: true)
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
        view.addSubview(indicatorView)
        
        indicatorView.center = view.center
        
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
        if motionDataList.isEmpty {
            presentSaveErrorAlert()
        }
        
        indicatorView.startAnimating()
        saveData()
    }
    
    @objc private func startMeasurement() {
        graphView.stopDrawLines()
        
        motionDataList = .init()
        jsonMotionData = .init()
        segmentControl.isUserInteractionEnabled = false
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        startTimer()
            
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
     
    @objc func timerCallback() {
        measureTime += 1
        
        if Int(measureTime) == 600 {
            stopTimer()
            motionManager.stopAccelerometerUpdates()
            motionManager.stopGyroUpdates()
            segmentControl.isUserInteractionEnabled = true
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }

    
    @objc private func stopMeasurement() {
        if measureTime != 0 {
            motionManager.stopAccelerometerUpdates()
            motionManager.stopGyroUpdates()
            segmentControl.isUserInteractionEnabled = true
            navigationItem.rightBarButtonItem?.isEnabled = true
            
            stopTimer()
            graphView.stopDrawLines()
        }
    }
}

// MARK: - CoreDataProcessable

extension AddViewController: CoreDataProcessable {}

// MARK: - AlertPresentable

extension AddViewController: AlertPresentable {}

// MARK: - NameSpace

private enum NameSpace {
    static let acc = "Acc"
    static let gyro = "Gyro"
    static let navigationItemTitle = "측정하기"
    static let navigationItemRightButtonTitle = "저장"
    static let playButtonTitle = "측정"
    static let stopButtonTitle = "정지"
    static let alertTitle = "측정 미진행"
    static let alertMessage = "데이터 저장을 하지 않습니까?"
    static let firstAlertActionTitle = "확인"
    static let secondAlertActionTitle = "취소"
}
