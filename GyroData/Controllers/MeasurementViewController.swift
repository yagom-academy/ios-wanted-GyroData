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

    // MARK: Measure
    private func measure() {
        measurementData = Measurement(sensor: selectedSensor, date: Date(), time: 0, axisValues: [])
        clearGraph()

        sensorManager.measure(sensor: selectedSensor, interval: 0.1, timeout: 600) { [weak self] data in
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

    // MARK: Save Data
    private func saveSensorData() {
        if measurementData.axisValues == [] {
            UIAlertController.show(title: "Error", message: "저장할 데이터가 없습니다.",target: self)
            print(DataHandleError.noDataError(detail: "측정한 데이터가 없습니다."))
            return
        }

        startActivityIndicator()

        storeDataInDevice {
            self.stopActivityIndicator()

            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: false)
            }
        }
    }

    private func storeDataInDevice(completion: @escaping ()->()) {
        DispatchQueue.global(qos: .default).asyncAfter(deadline: .now() + 1) {
            do {
                for manager in self.dataManagers {
                    try manager.saveData(self.measurementData)
                }
            } catch {
                UIAlertController.show(title: "Error",
                                       message: "데이터를 저장에 실패했습니다.",
                                       target: self)
                print(DataHandleError.saveFailError(error: error).description)
            }

            completion()
        }
    }

    // MARK: UserInteraction
    private func setDisabledUserInteraction() {
        measurementView.setDisabledSegments()
        navigationItem.rightBarButtonItem?.isEnabled = false
    }

    private func setEnabledUserInteraction() {
        measurementView.setEnabledSegments()
        navigationItem.rightBarButtonItem?.isEnabled = true
    }

    // MARK: Draw Graph
    private func drawGraph(with data: AxisValue) {
        measurementView.drawGraph(with: data)
    }

    private func clearGraph() {
        measurementView.clearGraph()
    }

    // MARK: Indicator
    private func startActivityIndicator() {
        self.measurementView.startActivityIndicator()
    }

    private func stopActivityIndicator() {
        DispatchQueue.main.async {
            self.measurementView.stopActivityIndicator()
        }
    }
}
