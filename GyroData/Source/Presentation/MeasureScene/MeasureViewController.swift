//
//  MeasureViewController.swift
//  GyroData
//
//  Created by Kyo, JPush on 2023/01/31.
//

import UIKit

class MeasureViewController: UIViewController {
    private enum Constant {
        static let title = "측정하기"
        static let rightBarButtonItemTitle = "저장"
        static let margin = CGFloat(16)
        static let saveFailAlertTitle = "저장 실패"
        static let saveFailAlertActionTitle = "확인"
        static let measureStartButtonTitle = "측정"
        static let measureStopButtonTitle = "정지"
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
    }
    
    func setupNavigationBar() {
        let rightBarButtonItem = UIBarButtonItem(
            title: Constant.rightBarButtonItemTitle,
            style: .plain,
            target: self,
            action: #selector(rightBarButtonTapped)
        )
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        self.navigationItem.title = Constant.title
    }
    
    func setupSegmentControl() {
        view.addSubview(segmentedControl)
        
        segmentedControl.selectedSegmentIndex = 0
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: safeArea.topAnchor),
            segmentedControl.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: Constant.margin),
            segmentedControl.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -Constant.margin),
        ])
    }
    
    func setupGraphView() {
        view.addSubview(graphView)
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            graphView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: Constant.margin),
            graphView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: Constant.margin),
            graphView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -Constant.margin),
            graphView.heightAnchor.constraint(equalTo: graphView.widthAnchor)
        ])
    }
    
    func setupMeasureButtons() {
        [measureStartButton, measureStopButton].forEach { view.addSubview($0) }
        
        measureStartButton.setTitle(Constant.measureStartButtonTitle, for: .normal)
        measureStopButton.setTitle(Constant.measureStopButtonTitle, for: .normal)
        
        measureStartButton.addTarget(self, action: #selector(measureStartButtonTapped), for: .touchUpInside)
        measureStopButton.addTarget(self, action: #selector(methodmeasureStopButtonTapped), for: .touchUpInside)
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            measureStartButton.topAnchor.constraint(equalTo: graphView.bottomAnchor, constant: Constant.margin * 2),
            measureStartButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: Constant.margin),
            
            measureStopButton.topAnchor.constraint(equalTo: measureStartButton.bottomAnchor, constant: Constant.margin * 2),
            measureStopButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: Constant.margin)
        ])
    }
    
    func setupActivityIndicator() {
        activityIndicatorView.center = self.view.center
        // do test 
    }
}

// MARK: - objc Method
extension MeasureViewController {
    @objc func rightBarButtonTapped(_ sender: UIBarButtonItem) {
        activityIndicatorView.startAnimating()
        let segment = segmentedControl.selectedSegmentIndex
        viewModel.action(.sensorTypeChanged(sensorType: Sensor(rawValue: segment)))
    }
    
    @objc func measureStartButtonTapped(_ sender: UIButton) {
        viewModel.action(.mesureStartButtonTapped)
    }
    
    @objc func methodmeasureStopButtonTapped(_ sender: UIButton) {
        viewModel.action(.measureEndbuttonTapped)
    }
}

extension MeasureViewController: MeasureViewDelegate {
    func updateValue(_ values: Values) {
        graphView.drawData(data: values)
    }
    
    func nonAccelerometerMeasurable() {
        
    }
    
    func nonGyroscopeMeasurable() {
        
    }
    
    func endMeasuringData() {
        
    }
    
    func saveSuccess() {
        activityIndicatorView.stopAnimating()
        self.navigationController?.popViewController(animated: true)
    }
    
    func saveFail(_ error: Error) {
        activityIndicatorView.stopAnimating()
        let alertController = UIAlertController(
            title: Constant.saveFailAlertTitle,
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        let defaultAction = UIAlertAction(
            title: Constant.saveFailAlertActionTitle,
            style: .default
        )
        
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true)
    }
}

import SwiftUI

struct PreView: PreviewProvider {
    static var previews: some View {
        let service = SensorMeasureService()
        let viewModel = MeasureViewModel(measureService: service)
        
        MeasureViewController(viewModel: viewModel).toPreview()
    }
}


#if DEBUG
extension UIViewController {
    private struct Preview: UIViewControllerRepresentable {
        let viewController: UIViewController
        
        func makeUIViewController(context: Context) -> UIViewController {
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        }
    }
    
    func toPreview() -> some View {
        Preview(viewController: self)
    }
}
#endif
