//
//  MeasureGyroDataViewController.swift
//  GyroData
//
//  Created by 리지 on 2023/06/13.
//

import UIKit
import Combine

final class MeasureGyroDataViewController: UIViewController {
    
    private let viewModel = MeasureViewModel()
    private var cancellables = Set<AnyCancellable>()
    private var selectedSensor: SensorType = .accelerometer
    private let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Acc", "Gyro"])
        
        return control
    }()
    
    private let graphView: GraphView = {
        let view = GraphView()
        let lineWidth: CGFloat = 3
        view.layer.borderWidth = lineWidth
        
        return view
    }()
    
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .leading
        
        return stackView
    }()
    
    private let measurementButton: UIButton = {
        let button = UIButton()
        let title = "측정"
        let fontSize: CGFloat = 25
        button.setTitle(title, for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        
        return button
    }()
    
    private let stopButton: UIButton = {
        let button = UIButton()
        let title = "정지"
        let fontSize: CGFloat = 25
        button.setTitle(title, for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        bind()
    }
    
    private func bind() {
        viewModel.accelerometerSubject
            .sink { [weak self] data in
                self?.graphView.drawGraph(with: data)
            }
            .store(in: &cancellables)
        viewModel.gyroscopeSubject
            .sink { [weak self] data in
                self?.graphView.drawGraph(with: data)
            }
            .store(in: &cancellables)
    }
    
    private func setUpView() {
        setUpNavigationBar()
        
        view.backgroundColor = .white
        setUpUI()
        setUpSegmentedControl()
        setUpButtons()
    }
    
    private func setUpNavigationBar() {
        let title = "측정하기"
        let save = "저장"
        let rightButtonItem = UIBarButtonItem(title: save,
                                              style: .plain,
                                              target: self,
                                              action: #selector(saveButtonTapped))
        navigationItem.title = title
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        navigationItem.rightBarButtonItem = rightButtonItem
        navigationController?.navigationBar.topItem?.title = ""
    }
    
    private func setUpSegmentedControl() {
        let fontSize: CGFloat = 20
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.selectedSegmentTintColor = .systemTeal
        
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: fontSize),
            .foregroundColor: UIColor.darkGray
            ]
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: fontSize),
            .foregroundColor: UIColor.white
            ]
        
        segmentedControl.setTitleTextAttributes(normalAttributes, for: .normal)
        segmentedControl.setTitleTextAttributes(selectedAttributes, for: .selected)
        segmentedControl.addTarget(self, action: #selector(changeSensorType), for: .valueChanged)
    }
    
    private func setUpUI() {
        view.addSubview(segmentedControl)
        view.addSubview(graphView)
        view.addSubview(labelStackView)
        labelStackView.addArrangedSubview(measurementButton)
        labelStackView.addArrangedSubview(stopButton)

        let safeArea = view.safeAreaLayoutGuide
        let segmentControlTop: CGFloat = 10
        let leading: CGFloat = 30
        let trailing: CGFloat = -30
        let contentsTop: CGFloat = 20
        let bottom: CGFloat = -140
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        graphView.translatesAutoresizingMaskIntoConstraints = false
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: segmentControlTop),
            segmentedControl.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: leading),
            segmentedControl.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: trailing),
            
            graphView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: contentsTop),
            graphView.leadingAnchor.constraint(equalTo: segmentedControl.leadingAnchor),
            graphView.trailingAnchor.constraint(equalTo: segmentedControl.trailingAnchor),
            graphView.widthAnchor.constraint(equalTo: graphView.heightAnchor),
            
            labelStackView.topAnchor.constraint(equalTo: graphView.bottomAnchor, constant: contentsTop),
            labelStackView.leadingAnchor.constraint(equalTo: segmentedControl.leadingAnchor),
            labelStackView.trailingAnchor.constraint(equalTo: segmentedControl.trailingAnchor),
            labelStackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: bottom)
        ])
    }
    
    private func setUpButtons() {
        measurementButton.addTarget(self, action: #selector(startMeasure), for: .touchUpInside)
        stopButton.addTarget(self, action: #selector(stopMeasure), for: .touchUpInside)
    }
}

// MARK: Button Action
extension MeasureGyroDataViewController {
    @objc private func changeSensorType(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            selectedSensor = .accelerometer
        case 1:
            selectedSensor = .gyroscope
        default:
            return
        }
    }
    
    @objc private func startMeasure() {
        if segmentedControl.isEnabled == false {
            segmentedControl.isEnabled = true
        } else {
            segmentedControl.isEnabled = false
        }
        viewModel.startMeasure(by: selectedSensor)
    }
    
    @objc private func stopMeasure() {
        segmentedControl.isEnabled = true
        viewModel.stopMeasure(by: selectedSensor)
    }
    
    @objc private func saveButtonTapped() {
        print("저장버튼이 눌렸습니다.")
    }
}
