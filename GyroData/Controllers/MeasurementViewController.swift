//
//  MeasurementViewController.swift
//  GyroData
//
//  Created by 로빈 on 2023/01/30.
//

import UIKit

final class MeasurementViewController: UIViewController {
    // MARK: View Properties
    private var graphView: LineGraphView = {
        let view = LineGraphView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()

    private lazy var segmentedController: UISegmentedControl = {
        let controller = UISegmentedControl(items: ["Acc", "Gyro"])
        controller.translatesAutoresizingMaskIntoConstraints = false
        controller.selectedSegmentIndex = 0
        controller.selectedSegmentTintColor = .systemBlue
        return controller
    }()

    private let graph: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemYellow
        return view
    }()

    private lazy var saveBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "저장", primaryAction: makeSaveButtonAction())
        return button
    }()

    private lazy var measurementButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("측정", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addAction(makeMeasurementButtonAction(), for: .touchUpInside)
        return button
    }()

    private lazy var stopButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("정지", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addAction(makeStopButtonAction(), for: .touchUpInside)
        return button
    }()

    // MARK: Properties
    private let manager: SensorManager
    private var data: [AxisData] = []

    private var selectedSensor: Sensor {
        guard let selectedSensor = Sensor(rawValue: segmentedController.selectedSegmentIndex) else { fatalError() }
        return selectedSensor
    }

    private var numberOfSegments: Int {
        return segmentedController.numberOfSegments
    }

    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        configureView()
        configureConstraints()
    }

    // MARK: Initialization
    init(manager: SensorManager = SensorManager(), data: [AxisData] = []) {
        self.manager = manager
        self.data = data

        super.init(nibName: nil, bundle: nil)
    }

    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: NavigationBar
    private func configureNavigationBar() {
        navigationItem.title = "측정하기"
        navigationItem.rightBarButtonItem = saveBarButton
    }

    // MARK: configure View
    private func configureView() {
        view.addSubview(measurementButton)
        view.addSubview(stopButton)
        view.addSubview(segmentedController)
        view.addSubview(graphView)
    }

    private func configureConstraints() {
        NSLayoutConstraint.activate([
            segmentedController.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            segmentedController.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            segmentedController.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),

            graphView.topAnchor.constraint(equalTo: segmentedController.bottomAnchor, constant: 16),
            graphView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            graphView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            graphView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),

            measurementButton.topAnchor.constraint(equalTo: graphView.bottomAnchor, constant: 16),
            measurementButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),

            stopButton.topAnchor.constraint(equalTo: measurementButton.bottomAnchor, constant: 16),
            stopButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
        ])
    }

    // MARK: Actions
    private func makeSaveButtonAction() -> UIAction {
        let action = UIAction { [weak self] _ in
            self?.saveSensorData()
        }

        return action
    }

    private func makeMeasurementButtonAction() -> UIAction {
        let action = UIAction { [weak self] _ in
            self?.measure()
        }

        return action
    }

    private func makeStopButtonAction() -> UIAction {
        let action = UIAction { [weak self] _ in
            self?.stop()
        }

        return action
    }

    // MARK: Methods
    private func measure() {
        data.removeAll()
        clearGraph()
        
        manager.measure(sensor: selectedSensor, interval: 0.1, timeout: 60) { [weak self] data in
            guard let data else {
                self?.setEnabledSegments()
                return
            }

            self?.data.append(data)
            print(data)
            self?.drawGraph(with: data)
        }

        setDisabledSegments()
    }

    private func stop() {
        manager.stop { _ in
            self.setEnabledSegments()
        }
    }

    private func saveSensorData() {
        fatalError()
    }

    private func setDisabledSegments() {
        for segmentIndex in 0..<numberOfSegments {
            // 선택되지 않은 세그먼트 제외 모두 비활성화
            if !(segmentedController.selectedSegmentIndex == segmentIndex) {
                segmentedController.setEnabled(false, forSegmentAt: segmentIndex)
            }
        }
    }

    private func setEnabledSegments() {
        for segmentIndex in 0..<numberOfSegments {
            // 비활성화된 세그먼트 활성화
            if !segmentedController.isEnabledForSegment(at: segmentIndex) {
                segmentedController.setEnabled(true, forSegmentAt: segmentIndex)
            }
        }
    }

    private func drawGraph(with data: AxisData) {
        graphView.addData(data)
    }

    private func clearGraph() {
        graphView.setData([])
    }
}
