//
//  MeasurementMotionDataViewController.swift
//  GyroData
//
//  Created by Aaron, Gundy on 2023/01/31.
//

import UIKit

class MeasurementMotionDataViewController: UIViewController {
    
    private let graphView = GraphView()
    private var currentMotion: MotionType = .accelerometer
    private lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: [MotionType.accelerometer.rawValue, MotionType.gyro.rawValue])
        segmentedControl.selectedSegmentIndex = .zero
        
        return segmentedControl
    }()
    
    private let xValueLabel: UILabel = {
        let label = UILabel()
        label.text = "x: 0"
        label.textColor = .red
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textAlignment = .left
        
        return label
    }()
    
    private let yValueLabel: UILabel = {
        let label = UILabel()
        label.text = "y: 0"
        label.textColor = .green
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textAlignment = .center
        
        return label
    }()
    
    private let zValueLabel: UILabel = {
        let label = UILabel()
        label.text = "z: 0"
        label.textColor = .blue
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textAlignment = .right
        
        return label
    }()
    
    private lazy var valueLabelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [xValueLabel,
                                                       yValueLabel,
                                                       zValueLabel])
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        
        return stackView
    }()
    
    private lazy var startMeasurementButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("측정",
                        for: .normal)
        button.addTarget(self,
                         action: #selector(startMeasurement),
                         for: .touchUpInside)
        
        return button
    }()
    
    private lazy var stopMeasurementButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("정지",
                        for: .normal)
        button.addTarget(self,
                         action: #selector(stopMeasurement),
                         for: .touchUpInside)
        button.isEnabled = false
        
        return button
    }()
    
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [segmentedControl,
                                                       valueLabelStackView,
                                                       graphView,
                                                       startMeasurementButton,
                                                       stopMeasurementButton])
        stackView.axis = .vertical
        stackView.setCustomSpacing(0, after: valueLabelStackView)
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        
        return view
    }()
    
    private lazy var rightBarButton = createSaveButton()
    
    private var measurementMotionDataViewModel: MeasurementMotionDataViewModel?

    init(measurementMotionDataViewModel: MeasurementMotionDataViewModel? = MeasurementMotionDataViewModel()) {
        self.measurementMotionDataViewModel = measurementMotionDataViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        configureViewModel()
        configureGraphView()
        configureLayout()
        configureNavigationBar()
    }
    
    private func configureViewModel() {
        measurementMotionDataViewModel?.bindMotionData { [weak self] in
            self?.graphView.setNeedsDisplay()
            guard let currentValue = self?.measurementMotionDataViewModel?.fetchCurrentValue() else {
                return
            }
            self?.xValueLabel.text = "x: " + currentValue.x
            self?.yValueLabel.text = "y: " + currentValue.y
            self?.zValueLabel.text = "z: " + currentValue.z
        }
    }
    
    private func configureGraphView() {
        graphView.backgroundColor = .systemBackground
        graphView.dataSource = measurementMotionDataViewModel
    }
    
    private func configureLayout() {
        view.addSubview(containerStackView)
        view.addSubview(loadingView)
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                           constant: 20),
            containerStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                               constant: 20),
            containerStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                constant: -20),
            containerStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                              constant: -200),
            segmentedControl.widthAnchor.constraint(equalTo: containerStackView.widthAnchor),
            valueLabelStackView.widthAnchor.constraint(equalTo: containerStackView.widthAnchor),
            graphView.widthAnchor.constraint(equalTo: containerStackView.widthAnchor),
            graphView.heightAnchor.constraint(equalTo: graphView.widthAnchor),
            loadingView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            loadingView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configureNavigationBar() {
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"),
                                      style: .plain,
                                      target: navigationController,
                                      action: #selector(UINavigationController.popViewController(animated:)))
        navigationItem.leftBarButtonItem = backButton
        navigationItem.leftBarButtonItem?.tintColor = .label
        navigationItem.rightBarButtonItem = rightBarButton
        navigationItem.title = "측정하기"
    }
    
    private func createSaveButton() -> UIBarButtonItem {
        let button = UIBarButtonItem(title: "저장", primaryAction: createSaveAction())
        
        return button
    }
    
    private func createSaveAction() -> UIAction {
        let action = UIAction { [weak self] _ in
            self?.loadingView.isHidden = false
            guard let list = self?.measurementMotionDataViewModel?.fetchData(),
                  list.isEmpty == false else {
                self?.loadingView.isHidden = true
                self?.showErrorAlert(message: "측정값이 없습니다.")
                return
            }
            let fileManager = FileManager.shared
            do {
                switch self?.currentMotion {
                case .accelerometer:
                    try fileManager.createMotionData(type: .accelerometer,
                                                     time: Double(list.count) / 10,
                                                     value: list)
                    self?.navigationController?.popViewController(animated: true)
                default:
                    try fileManager.createMotionData(type: .gyro,
                                                     time: Double(list.count) / 10,
                                                     value: list)
                    self?.navigationController?.popViewController(animated: true)
                }
            } catch {
                self?.loadingView.isHidden = true
              self?.showErrorAlert(message: "CoreData 저장에 실패했습니다.")
            }
        }
        
        return action
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "저장 실패",
                                      message: message,
                                      preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "확인",
                                       style: .default)
        alert.addAction(doneAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    @objc
    private func startMeasurement() {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            currentMotion = .accelerometer
            measurementMotionDataViewModel?.startUpdates(.accelerometer)
        default:
            currentMotion = .gyro
            measurementMotionDataViewModel?.startUpdates(.gyro)
        }
        configureEnabled(state: .start)
    }
    
    @objc
    private func stopMeasurement() {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            measurementMotionDataViewModel?.stopUpdates(.accelerometer)
        default:
            measurementMotionDataViewModel?.stopUpdates(.gyro)
        }
        configureEnabled(state: .stop)
    }
    
    private func configureEnabled(state: MeasurementState) {
        switch state {
        case .start:
            rightBarButton.isEnabled = false
            segmentedControl.isEnabled = false
            stopMeasurementButton.isEnabled = true
        case .stop:
            rightBarButton.isEnabled = true
            segmentedControl.isEnabled = true
            stopMeasurementButton.isEnabled = false
        }
    }
}

extension MeasurementMotionDataViewController {
    
    enum MeasurementState {
        
        case start
        case stop
    }
}
