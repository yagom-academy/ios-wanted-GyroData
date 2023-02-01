//
//  MeasurementViewController.swift
//  GyroData
//
//  Created by 로빈 on 2023/01/30.
//

import UIKit

final class MeasurementViewController: UIViewController {
    // MARK: Properties
    private let measurementView = MeasurementView()
    private let sensorManager = SensorManager()
    private let dataManagers: [any MeasurementDataHandleable]

    private var measurementData = Measurement(sensor: .Accelerometer, date: Date(), time: 0, axisValues: [])
    private var axisValues: [AxisValue] = []

    private var selectedSensor: Sensor {
        return measurementView.selectedSensor
    }

    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view = measurementView

        configureNavigationBar()
        configureViewButtonActions()
    }

    // MARK: Initialization
    init(dataManagers: [any MeasurementDataHandleable]) {
        self.dataManagers = dataManagers

        super.init(nibName: nil, bundle: nil)
    }

    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: NavigationBar
    private func configureNavigationBar() {
        let saveAction = UIAction { [weak self] _ in
            self?.saveSensorData()
        }

        let saveButton = UIBarButtonItem(title: "저장", primaryAction: saveAction)

        navigationItem.title = "측정하기"
        navigationItem.rightBarButtonItem = saveButton
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
        measurementData = Measurement(sensor: selectedSensor, date: Date(), time: 0, axisValues: [])
        clearGraph()

        sensorManager.measure(sensor: selectedSensor, interval: 0.1, timeout: 60) { [weak self] data in
            guard let data else {
                self?.setEnabledSegments()
                return
            }

            self?.axisValues.append(data)
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
        measurementData.axisValues = axisValues
        measurementData.time = 0.1 * Double(measurementData.axisValues.count)
    }
    
    private func saveSensorData() {
        // 비동기 저장 구현해야함
        do {
            for manager in dataManagers {
                try manager.saveData(measurementData)
            }
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
