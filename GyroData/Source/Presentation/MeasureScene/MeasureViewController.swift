//
//  MeasureViewController.swift
//  GyroData
//
//  Created by Kyo, JPush on 2023/01/31.
//

import UIKit

final class MeasureViewController: UIViewController {
    private enum Constant {
        static let title = "측정하기"
        static let rightBarButtonItemTitle = "저장"
        static let margin = CGFloat(16)
        
        static let saveFailAlertTitle = "저장 실패"
        static let saveFailAlertActionTitle = "확인"
        
        static let measureStartButtonTitle = "측정"
        static let measureStopButtonTitle = "정지"
        
        static let sensorErrorAlertTitle = "센서 에러"
        static let accelerometerSensorErrorActionTitle = "가속도 센서 사용 불가"
        static let gyroscopeSensorErrorActionTitle = "자이로 센서 사용 불가"
    }
    
    private let segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: [
            Sensor.accelerometer.description,
            Sensor.gyroscope.description
        ])
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        return segmentedControl
    }()
    
    private let graphView: GraphView = {
        let graphView = GraphView(interval: 0.1, duration: 60)
        graphView.translatesAutoresizingMaskIntoConstraints = false
        graphView.backgroundColor = .systemGray6
        return graphView
    }()
    
    private let measureStartButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .title2)
        return button
    }()
    
    private let measureStopButton: UIButton = {
        let button = UIButton()
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .title2)
        return button
    }()
    
    private let activityIndicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        
        return indicator
    }()
    
    private let viewModel: MeasureViewModel
    
    init(viewModel: MeasureViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        setViewModelDelegate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupSegmentControl()
        setupGraphView()
        setupMeasureButtons()
        setupActivityIndicator()
    }
}

private extension MeasureViewController {
    func setViewModelDelegate() {
        self.viewModel.delegate = self
        self.viewModel.alertDelegate = self
    }
    
    func setupNavigationBar() {
        let rightBarButtonItem = UIBarButtonItem(
            title: Constant.rightBarButtonItemTitle,
            style: .plain,
            target: self,
            action: #selector(rightBarButtonTapped)
        )
        rightBarButtonItem.isEnabled = false
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        self.navigationItem.title = Constant.title
        
    }
    
    func setupSegmentControl() {
        view.addSubview(segmentedControl)
        
        segmentedControl.addTarget(
            self,
            action: #selector(segmentedControlValueChanged),
            for: .valueChanged
        )
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(
                equalTo: safeArea.topAnchor,
                constant: Constant.margin
            ),
            segmentedControl.leadingAnchor.constraint(
                equalTo: safeArea.leadingAnchor,
                constant: Constant.margin
            ),
            segmentedControl.trailingAnchor.constraint(
                equalTo: safeArea.trailingAnchor, constant: -Constant.margin
            ),
        ])
    }
    
    func setupGraphView() {
        view.addSubview(graphView)
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            graphView.topAnchor.constraint(
                equalTo: segmentedControl.bottomAnchor,
                constant: Constant.margin
            ),
            graphView.leadingAnchor.constraint(
                equalTo: safeArea.leadingAnchor,
                constant: Constant.margin
            ),
            graphView.trailingAnchor.constraint(
                equalTo: safeArea.trailingAnchor,
                constant: -Constant.margin
            ),
            graphView.heightAnchor.constraint(equalTo: graphView.widthAnchor)
        ])
    }
    
    func setupMeasureButtons() {
        [measureStartButton, measureStopButton].forEach { view.addSubview($0) }
        
        measureStartButton.setTitle(Constant.measureStartButtonTitle, for: .normal)
        measureStopButton.setTitle(Constant.measureStopButtonTitle, for: .normal)
        
        measureStartButton.addTarget(
            self,
            action: #selector(measureStartButtonTapped),
            for: .touchUpInside
        )
        measureStopButton.addTarget(
            self,
            action: #selector(measureStopButtonTapped),
            for: .touchUpInside
        )
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            measureStartButton.topAnchor.constraint(
                equalTo: graphView.bottomAnchor,
                constant: Constant.margin * 2
            ),
            measureStartButton.leadingAnchor.constraint(
                equalTo: safeArea.leadingAnchor,
                constant: Constant.margin
            ),
            
            measureStopButton.topAnchor.constraint(
                equalTo: measureStartButton.bottomAnchor,
                constant: Constant.margin * 2
            ),
            measureStopButton.leadingAnchor.constraint(
                equalTo: safeArea.leadingAnchor,
                constant: Constant.margin
            )
        ])
    }
    
    func setupActivityIndicator() {
        view.addSubview(activityIndicatorView)
        
        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
        view.bringSubviewToFront(activityIndicatorView)
    }
    
    func setUserInteractive(_ setValue: Bool) {
        segmentedControl.isEnabled = setValue
        measureStartButton.isEnabled = setValue
        measureStopButton.isEnabled = !setValue
        navigationItem.backBarButtonItem?.isEnabled = setValue
    }
}

// MARK: - objc Method
extension MeasureViewController {
    @objc func rightBarButtonTapped(_ sender: UIBarButtonItem) {
        activityIndicatorView.startAnimating()
        viewModel.action(.saveButtonTapped)
    }
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        let segment = Sensor(rawValue: sender.selectedSegmentIndex)
        viewModel.action(.sensorTypeChanged(sensorType: segment))
    }
    
    @objc func measureStartButtonTapped(_ sender: UIButton) {
        guard segmentedControl.selectedSegmentIndex != -1 else { return }
        graphView.dataInit()
        setUserInteractive(false)
        viewModel.action(.mesureStartButtonTapped)
    }
    
    @objc func measureStopButtonTapped(_ sender: UIButton) {
        viewModel.action(.measureEndbuttonTapped)
        navigationItem.rightBarButtonItem?.isEnabled = true
        setUserInteractive(true)
    }
}

extension MeasureViewController: MeasureViewDelegate {
    func updateValue(_ values: Values) {
        graphView.drawData(data: values)
        graphView.setNeedsDisplay()
    }
    
    func endMeasuringData() {
        setUserInteractive(true)
    }
    
    func activeSave() {
        navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    func saveSuccess() {
        activityIndicatorView.stopAnimating()
        self.navigationController?.popViewController(animated: true)
    }
    
    func saveFail(_ error: Error) {
        activityIndicatorView.stopAnimating()
    }
}

extension MeasureViewController: AlertPresentable {
    func presentErrorAlert(title: String, message: String) {
        let errorAlert = AlertDirector().setupErrorAlert(
            builder: ErrorAlertBuilder(),
            title: title,
            errorMessage: message
        )
        setUserInteractive(true)
        present(errorAlert, animated: true)
    }

}
