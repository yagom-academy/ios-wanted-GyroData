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
    
    private var threeAxisData: [ThreeAxisValue]?
//    private var gyroThreeAxisData: [ThreeAxisValue]?
    
    private var selectedSensor: SensorType = .accelerometer
    private let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Acc", "Gyro"])
        
        return control
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
       let activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = view.center
        activityIndicator.style = UIActivityIndicatorView.Style.large
        activityIndicator.color = .systemGreen
        activityIndicator.hidesWhenStopped = true
        
        return activityIndicator
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
                self?.threeAxisData = data
                self?.graphView.drawGraph(with: data)
            }
            .store(in: &cancellables)
        viewModel.gyroscopeSubject
            .sink { [weak self] data in
                self?.threeAxisData = data
                self?.graphView.drawGraph(with: data)
            }
            .store(in: &cancellables)
    }
    
    private func setUpView() {
        setUpNavigationBar()
        
        view.backgroundColor = .white
        setUpUI()
        setUpActivityIndicator()
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
    
    private func setUpActivityIndicator() {
        view.addSubview(activityIndicator)
        
        let safeArea = view.safeAreaLayoutGuide
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.topAnchor.constraint(equalTo: safeArea.topAnchor),
            activityIndicator.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            activityIndicator.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            activityIndicator.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
            ])
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
    
    private func showAlert() {
        let title = "측정된 데이터가 없습니다."
        let message = "다시 확인해주세요."
        let okSign = "확인"
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: okSign, style: .default)
        
        alert.addAction(okAction)
        present(alert, animated: true)
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
        viewModel.startMeasure(by: selectedSensor)
        bindIsProcessing()
    }
    
    @objc private func stopMeasure() {
        viewModel.stopMeasure(by: selectedSensor)
        bindIsProcessing()
    }
    
    private func bindIsProcessing() {
        viewModel.isProcessingSubject
            .sink { [weak self] bool in
                if bool == true {
                    self?.segmentedControl.isEnabled = false
                    self?.navigationItem.rightBarButtonItem?.isEnabled = false
                } else {
                    self?.segmentedControl.isEnabled = true
                    self?.navigationItem.rightBarButtonItem?.isEnabled = true
                }
            }
            .store(in: &cancellables)
    }
    
    @objc private func saveButtonTapped() {
        bindIsSaving()
        if let threeAxisData = threeAxisData {
            let data = SixAxisDataForJSON(date: Date(), title: selectedSensor.description, threeAxisValue: threeAxisData)
            viewModel.saveToFileManager(data)
        } else {
            showAlert()
        }
    }
    
    private func bindIsSaving() {
        viewModel.isSavingSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] bool in
                if bool == true {
                print("인디케이터시작")
                    self?.activityIndicator.startAnimating()
                } else {
                    print("인디케이터종료")
                    self?.activityIndicator.stopAnimating()
                }
            }
            .store(in: &cancellables)
    }
}
