//
//  MotionMeasureViewController.swift
//  GyroData
//
//  Created by Ayaan, Wonbi on 2023/01/31.
//

import UIKit

final class MotionMeasureViewController: UIViewController {
    enum Constant {
        static let title = "측정하기"
        static let measureButtonTitle = "측정"
        static let stopButtonTitle = "정지"
        static let saveButtonTitle = "저장"
        static let accelerometerTitle = "Acc"
        static let gyroTitle = "Gyro"
        static let dateFormat = "yyyy/MM/dd HH:mm:ss"
        static let margin = CGFloat(16.0)
        static let spacing = CGFloat(8.0)
    }
    private let measurementTypeSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: [Motion.MeasurementType.acc.text,
                                                          Motion.MeasurementType.gyro.text])
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()
    private let graphView = UIView()
    private let measureButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constant.measureButtonTitle, for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitleColor(.systemGray3, for: .disabled)
        return button
    }()
    private let spacingView = UILayoutGuide()
    private let stopButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constant.stopButtonTitle, for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitleColor(.systemGray3, for: .disabled)
        button.isEnabled = false
        return button
    }()
    private let saveBarButton = UIBarButtonItem(title: Constant.saveButtonTitle,
                                                style: .plain,
                                                target: nil,
                                                action: nil)
    private let contentsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = Constant.spacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let viewModel: MotionMeasurementViewModel
    
    init(viewModel: MotionMeasurementViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupButtons()
        viewModel.configureDelegate(self)
    }
}

private extension MotionMeasureViewController {
    func setupUI() {
        let safeArea = view.safeAreaLayoutGuide
        
        view.backgroundColor = .systemBackground
        title = Constant.title
        
        [measurementTypeSegmentedControl,
         graphView,
         measureButton,
         stopButton
        ].forEach(contentsStackView.addArrangedSubview(_:))
        view.addLayoutGuide(spacingView)
        view.addSubview(contentsStackView)
        
        NSLayoutConstraint.activate([
            contentsStackView.topAnchor.constraint(equalTo: safeArea.topAnchor,
                                                   constant: Constant.margin),
            contentsStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor,
                                                       constant: Constant.margin),
            contentsStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor,
                                                        constant: -Constant.margin),
            contentsStackView.bottomAnchor.constraint(lessThanOrEqualTo: safeArea.bottomAnchor,
                                                      constant: -Constant.margin),
            measurementTypeSegmentedControl.widthAnchor.constraint(equalTo: contentsStackView.widthAnchor),
            graphView.widthAnchor.constraint(equalTo: contentsStackView.widthAnchor),
            graphView.widthAnchor.constraint(equalTo: graphView.heightAnchor)
        ])
    }
    
    func setupButtons() {
        saveBarButton.target = self
        saveBarButton.action = #selector(saveMotion)
        navigationItem.rightBarButtonItem = saveBarButton
        
        measureButton.addTarget(self, action: #selector(measureMotion), for: .touchUpInside)
        stopButton.addTarget(self, action: #selector(stopMeasurement), for: .touchUpInside)
    }
    
    @objc func saveMotion() {
        viewModel.action(.motionCreate(date: Date().formatted(by: Constant.dateFormat),
                                       type: measurementTypeSegmentedControl.selectedSegmentIndex,
                                       time: "",
                                       data: []))
    }
    
    @objc func measureMotion() {
        viewModel.action(.measurementStart(type: measurementTypeSegmentedControl.selectedSegmentIndex))
        stopButton.isEnabled = true
        measureButton.isEnabled = false
        saveBarButton.isEnabled = false
        measurementTypeSegmentedControl.isEnabled = false
    }
    
    @objc func stopMeasurement() {
        viewModel.action(.measurementStop(type: measurementTypeSegmentedControl.selectedSegmentIndex))
        stopButton.isEnabled = false
        measureButton.isEnabled = true
        saveBarButton.isEnabled = true
        measurementTypeSegmentedControl.isEnabled = true
    }
}

extension MotionMeasureViewController: MotionMeasurementViewModelDelegate {
    func motionMeasurementViewModel(measuredData data: MotionDataType, takenCurrentTime time: Double) {
        
    }
    
    func motionMeasurementViewModel(isCompletedInMotionMeasurement: Bool) {
        if isCompletedInMotionMeasurement {
            stopButton.isEnabled = false
            measureButton.isEnabled = true
            saveBarButton.isEnabled = true
            measurementTypeSegmentedControl.isEnabled = true
        }
    }
    
    func motionMeasurementViewModel(isSucceedInCreating: Bool) {
        navigationController?.popViewController(animated: true)
    }
    
    func motionMeasurementViewModel(alertStyleToPresent: AlertStyle) {
        
    }
}
