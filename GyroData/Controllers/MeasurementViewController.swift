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

        // 테스트를 위해 타임아웃60(0.1*60 = 6초).최종제출전 타임아웃 600(60초)로 수정할 예정.
        sensorManager.measure(sensor: selectedSensor, interval: 0.1, timeout: 60) { [weak self] data in
            guard let data else {
                self?.stop()
                return
            }

            self?.axisValues.append(data)
            print(data)
            self?.drawGraph(with: data)
        }

        setDisabledUserInteraction()
    }

    private func stop() {
        sensorManager.stop { [weak self] _ in
            self?.setEnabledUserInteraction()
            self?.updateMeasurementData()
        }
    }
    
    private func updateMeasurementData() {
        measurementData.axisValues = axisValues
        measurementData.time = 0.1 * Double(measurementData.axisValues.count)
    }
    
    private func saveSensorData() {
        if measurementData.axisValues == [] {
            showAlert(title: "Error",
                      message: DataHandleError.noDataError(detail: "측정한 데이터가 없습니다.").description)
        }

        do {
            for manager in dataManagers {
                try manager.saveData(measurementData)
                // 데이터 저장은 비동기로 처리하고 Activity Indicator를 표시해주세요.
                // 저장이 성공하면 Indicator를 닫고, 첫 번째 페이지로 이동합니다.
            }
        } catch {
            showAlert(title: "Error", message: DataHandleError.saveFailError(error: error).description)
        }
    }
    
    private func setDisabledUserInteraction() {
        measurementView.setDisabledSegments()
        navigationItem.rightBarButtonItem?.isEnabled = false
    }

    private func setEnabledUserInteraction() {
        measurementView.setEnabledSegments()
        navigationItem.rightBarButtonItem?.isEnabled = true
    }

    private func drawGraph(with data: AxisValue) {
        measurementView.drawGraph(with: data)
    }

    private func clearGraph() {
        measurementView.clearGraph()
    }
}
