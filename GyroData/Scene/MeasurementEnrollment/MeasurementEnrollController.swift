//
//  MeasurementEnrollController.swift
//  GyroData
//
//  Created by 백곰, 바드 on 2022/12/26.
//

import UIKit

final class MeasurementEnrollController: UIViewController {
    
    // MARK: Properties
    
    private let motionManager = MotionManager()
    private let segmentControl = CustomSegmentedControl(items: ["Acc", "Gyro"])
    private let segmentControlShadowView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.layer.borderWidth = 2
        return view
    }()
    
    private let graphView = GridView()
    
    private let measurementButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("측정", for: .normal)
        button.setTitleColor(.tintColor, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        return button
    }()
    
    private let measurementStopButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("정지", for: .normal)
        button.setTitleColor(.tintColor, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        return button
    }()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commonInit()
    }
    
    // MARK: - Methods
    
    private func commonInit() {
        setupBackgroundColor(.systemBackground)
        setupNavigationBar()
        setupSubview()
        setupConstraint()
        setupMeasurementButton()
        setupMeasurementStopButton()
    }
    
    private func setupBackgroundColor(_ color: UIColor?) {
        view.backgroundColor = color
    }
    
    private func setupNavigationBar() {
        setupNavigationBarTitle()
        setupNavigationBackButton()
        setupNavigationRightBarButton()
    }
    
    private func setupNavigationBarTitle() {
        navigationItem.title = "측정하기"
        let attribute = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 25)
        ]
        navigationController?.navigationBar.titleTextAttributes = attribute
    }
    
    private func setupNavigationBackButton() {
        let backButton = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
        backButton.tintColor = .black
        navigationItem.leftBarButtonItem = backButton
    }
    
    private func setupNavigationRightBarButton() {
        let saveButton = UIBarButtonItem(
            title: "저장",
            style: .plain,
            target: self,
            action: #selector(saveButtonTapped)
        )
        navigationItem.rightBarButtonItem = saveButton
    }
    
    private func setupMeasurementButton() {
        measurementButton.addTarget(
            self,
            action: #selector(measurementButtonTapped),
            for: .touchUpInside
        )
    }
    
    private func setupMeasurementStopButton() {
        measurementStopButton.addTarget(
            self,
            action: #selector(measurementStopButtonTapped),
            for: .touchUpInside
        )
    }
    
    private func setupSubview() {
        [segmentControlShadowView, segmentControl,graphView,
         measurementButton, measurementStopButton]
            .forEach { view.addSubview($0) }
    }
    
    private func setupConstraint() {
        setupSegmentControlConstraint()
        setupSegmentControlShadowViewConstraint()
        setupGraphViewConstraint()
        setupMeasurementButtonConstraint()
        setupMeasurementStopButtonConstraint()
    }
    
    private func setupSegmentControlConstraint() {
        NSLayoutConstraint.activate([
            segmentControl.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 40
            ),
            segmentControl.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 32
            ),
            segmentControl.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -40
            ),
            segmentControl.heightAnchor.constraint(
                equalToConstant: 28
            )
        ])
    }
    
    private func setupSegmentControlShadowViewConstraint() {
        NSLayoutConstraint.activate([
            segmentControlShadowView.widthAnchor.constraint(
                equalTo: segmentControl.widthAnchor
            ),
            segmentControlShadowView.heightAnchor.constraint(
                equalTo: segmentControl.heightAnchor
            ),
            segmentControlShadowView.leadingAnchor.constraint(
                equalTo: segmentControl.leadingAnchor,
                constant: 2
            ),
            segmentControlShadowView.topAnchor.constraint(
                equalTo: segmentControl.topAnchor,
                constant: 2
            )
        ])
    }
    
    private func setupGraphViewConstraint() {
        NSLayoutConstraint.activate([
            graphView.topAnchor.constraint(
                equalTo: segmentControl.bottomAnchor,
                constant: 32
            ),
            graphView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 32
            ),
            graphView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -40
            ),
            graphView.heightAnchor.constraint(
                equalTo: graphView.widthAnchor
            )
        ])
    }
    
    private func setupMeasurementButtonConstraint() {
        NSLayoutConstraint.activate([
            measurementButton.topAnchor.constraint(
                equalTo: graphView.bottomAnchor,
                constant: 40
            ),
            measurementButton.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 32
            )
        ])
    }
    
    private func setupMeasurementStopButtonConstraint() {
        NSLayoutConstraint.activate([
            measurementStopButton.topAnchor.constraint(
                equalTo: measurementButton.bottomAnchor,
                constant: 52
            ),
            measurementStopButton.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 32
            )
        ])
    }
    
    @objc private func measurementButtonTapped() {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            motionManager.startAccelerometerRecord()
        case 1:
            motionManager.stopGyroRecord()
        default:
            break
        }
    }
    
    @objc private func measurementStopButtonTapped() {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            motionManager.stopAccelerometerRecord()
        case 1:
            motionManager.stopGyroRecord()
        default:
            break
        }
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func saveButtonTapped() {
        
        switch segmentControl.selectedSegmentIndex {
        case 0:
            motionManager.stopAccelerometerRecord()
        case 1:
            motionManager.stopGyroRecord()
        default:
            break
        }
    }
}
