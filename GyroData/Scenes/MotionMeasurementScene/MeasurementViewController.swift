//
//  MeasurementViewController.swift
//  GyroData
//
//  Created by Judy on 2022/12/27.
//

import UIKit

class MeasurementViewController: UIViewController {
    private let entireStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Acc", "Gyro"])
        control.selectedSegmentIndex = 0
        control.selectedSegmentTintColor = .systemCyan
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    private let graphView: GraphView = {
        let graph = GraphView()
        graph.translatesAutoresizingMaskIntoConstraints = false
        return graph
    }()
    
    private let measurementButton: UIButton = {
        let button = UIButton()
        button.setTitle("측정", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .title2)
        button.contentHorizontalAlignment = .left
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let stopButton: UIButton = {
        let button = UIButton()
        button.setTitle("정지", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .title2)
        button.contentHorizontalAlignment = .left
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let measurementviewModel = MotionMeasurementViewModel()
    private var motionType = MotionType.acc
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        configureNavigationBar()
        configureButton()
        bind()
    }
    
    private func setupView() {
        addSubViews()
        setupConstraints()
        view.backgroundColor = .systemBackground
    }
    
    private func addSubViews() {
        entireStackView.addArrangedSubview(segmentedControl)
        entireStackView.addArrangedSubview(graphView)
        entireStackView.addArrangedSubview(measurementButton)
        entireStackView.addArrangedSubview(stopButton)
        
        view.addSubview(entireStackView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            entireStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                                 constant: 16),
            entireStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                                 constant: 16),
            entireStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                 constant: -16),
            
            graphView.heightAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }
    
    private func bind() {
        measurementviewModel.isMeasuring
            .subscribe { [weak self] isMeasuring in
                self?.segmentedControl.isEnabled = !isMeasuring
                self?.stopButton.isEnabled = isMeasuring
            }
    }
}

extension MeasurementViewController {
    private func configureNavigationBar() {
        let saveBarButton = UIBarButtonItem(title: "저장",
                                            style: .done,
                                            target: self,
                                            action: #selector(saveButtonTapped))
        
        navigationItem.rightBarButtonItem = saveBarButton
        navigationItem.title = "측정하기"
    }
    
    @objc private func saveButtonTapped() {
        measurementviewModel.save(motionType, datas: graphView.segmentDatas)
        navigationController?.popViewController(animated: true)
    }
    
    private func configureButton() {
        measurementButton.addTarget(self,
                             action: #selector(measureButtonTapped),
                             for: .touchUpInside)
        
        stopButton.addTarget(self,
                             action: #selector(stopButtonTapped),
                             for: .touchUpInside)
        
        segmentedControl.addTarget(self,
                                   action: #selector(segmentedContorolSelected),
                                   for: .valueChanged)
    }
    
    @objc private func measureButtonTapped() {
        measurementviewModel.startMeasurement(motionType, on: graphView)
    }
    
    @objc private func stopButtonTapped() {
        measurementviewModel.stopMeasurement(motionType)
    }
    
    @objc private func segmentedContorolSelected() {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            motionType = .acc
        case 1:
            motionType = .gyro
        default:
            motionType = .acc
        }
    }
}
