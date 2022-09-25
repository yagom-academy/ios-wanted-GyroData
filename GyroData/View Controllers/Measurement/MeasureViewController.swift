//
//  MeasureViewController.swift
//  GyroData
//
//  Created by sole on 2022/09/24.
//

import UIKit

final class MeasureViewController: UIViewController {
    
    let segmentControl: UISegmentedControl = {
       let control = UISegmentedControl(items: ["Acc", "Gyro"])
        control.translatesAutoresizingMaskIntoConstraints = false
        control.selectedSegmentIndex = 0
        return control
    }()
    
    let graphView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var measureButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapMeasureButton), for: .touchUpInside)
        button.setTitle("측정", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.isEnabled = true
        return button
    }()
    
    lazy var stopButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapStopButton), for: .touchUpInside)
        button.setTitle("정지", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.isEnabled = false 
        return button
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.style = .large
        return indicator
    }()
    
    let coreMotionService = CoreMotionService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        configureViews()
        configureLayout()
    }
    
    private func configureNavigation() {
        navigationItem.title = "측정하기"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(didTapSaveButton))
    }
    
    private func configureViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(segmentControl)
        view.addSubview(graphView)
        view.addSubview(measureButton)
        view.addSubview(stopButton)
        view.addSubview(activityIndicator)
    }
    
    private func configureLayout() {
        NSLayoutConstraint.activate([
            segmentControl.topAnchor.constraint(equalTo: view.topAnchor, constant: 130),
            segmentControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            segmentControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            segmentControl.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            graphView.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 16),
            graphView.leadingAnchor.constraint(equalTo: segmentControl.leadingAnchor),
            graphView.trailingAnchor.constraint(equalTo: segmentControl.trailingAnchor),
            graphView.heightAnchor.constraint(equalTo: graphView.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            measureButton.topAnchor.constraint(equalTo: graphView.bottomAnchor, constant: 30),
            measureButton.leadingAnchor.constraint(equalTo: segmentControl.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            stopButton.topAnchor.constraint(equalTo: measureButton.bottomAnchor, constant: 20),
            stopButton.leadingAnchor.constraint(equalTo: segmentControl.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc
    private func didTapMeasureButton() {
        self.coreMotionService.startMeasurement(of: MotionType(rawValue: segmentControl.selectedSegmentIndex) ?? .acc,
                                                completion: { self.changeButtonsState() })
    }
    
    @objc
    private func didTapStopButton() {
        self.coreMotionService.stopMeasurement(of: MotionType(rawValue: segmentControl.selectedSegmentIndex) ?? .acc)
    }
    
    private func changeButtonsState() {
        measureButton.isEnabled = !self.measureButton.isEnabled
        self.stopButton.isEnabled = !self.measureButton.isEnabled
        self.navigationItem.rightBarButtonItem?.isEnabled = self.measureButton.isEnabled
        self.segmentControl.isEnabled = self.measureButton.isEnabled
    }
    
    @objc
    private func didTapSaveButton() {
        activityIndicator.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.activityIndicator.stopAnimating()
        }
    }
}
