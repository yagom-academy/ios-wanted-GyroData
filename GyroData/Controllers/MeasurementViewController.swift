//
//  MeasurementViewController.swift
//  GyroData
//
//  Created by 로빈 on 2023/01/30.
//

import UIKit

final class MeasurementViewController: UIViewController {
    // MARK: Properties
    private let measurementView: MeasurementView = {
        let view = MeasurementView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let sensorManager: SensorManager
    private let fileManager: SensorFileManager

    private var measurementData = Measurement(sensor: .Accelerometer, date: Date(), time: 0, axisValue: [])
    private var axisValue: [AxisValue] = []

    private var selectedSensor: Sensor {
        return measurementView.selectedSensor
    }

    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        configureView()
        configureConstraints()
        configureViewButtonActions()

        print(fileManager.fetchData())
    }

    // MARK: Initialization
    init(sensorManager: SensorManager = SensorManager(), fileManager: SensorFileManager = SensorFileManager()) {
        self.sensorManager = sensorManager
        self.fileManager = fileManager

        super.init(nibName: nil, bundle: nil)
    }

    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: NavigationBar
    private func configureNavigationBar() {
        let savaAction = UIAction { [weak self] _ in
            self?.saveSensorData()
        }

        let saveButton = UIBarButtonItem(title: "저장", primaryAction: savaAction)

        navigationItem.title = "측정하기"
        navigationItem.rightBarButtonItem = saveButton
    }

    private func configureView() {
        view.addSubview(measurementView)
    }

    private func configureConstraints() {
        NSLayoutConstraint.activate([
            measurementView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            measurementView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            measurementView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            measurementView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func configureViewButtonActions() {
        let measureButtonAction = UIAction { [weak self] _ in
            self?.measure()
        }

        let stopButtonAction = UIAction { [weak self] _ in
            self?.stop()
        }

        measurementView.configureMeasurementButtonAction(measureButtonAction)
        measurementView.configureStopButtonAction(stopButtonAction)
    }

    private func measure() {
        measurementData = Measurement(sensor: selectedSensor, date: Date(), time: 0, axisValue: [])
        clearGraph()

        sensorManager.measure(sensor: selectedSensor, interval: 0.1, timeout: 60) { [weak self] data in
            guard let data else {
                self?.setEnabledSegments()
                return
            }

            self?.measurementData.axisValue.append(data)
            print(data)
            self?.drawGraph(with: data)
        }

        setDisabledSegments()
    }

    private func stop() {
        sensorManager.stop { [weak self] _ in
            self?.setEnabledSegments()
            self?.updateMeasurementData()
        }
    }

    private func updateMeasurementData() {
        measurementData.axisValue = axisValue
        measurementData.time = 0.1 * Double(measurementData.axisValue.count)
    }

    private func saveSensorData() {
        do {
            try fileManager.saveData(measurementData)
        } catch {
            fatalError("얼럿추가해야됨")
        }
    }

    private func setDisabledSegments() {
        measurementView.setDisabledSegments()
    }

    private func setEnabledSegments() {
        measurementView.setEnabledSegments()
    }

    private func drawGraph(with data: AxisValue) {
        measurementView.drawGraph(with: data)
    }

    private func clearGraph() {
        measurementView.clearGraph()
    }
}
