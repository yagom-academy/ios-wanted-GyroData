//
//  MeasurementViewController.swift
//  GyroData
//
//  Created by 로빈 on 2023/01/30.
//

import UIKit

final class MeasurementViewController: UIViewController {
    
    private let measurementView = MeasurementView()
    private let sensorManager = SensorManager()
    private let dataManagers: [any MeasurementDataHandleable]
    
    private var measurement = Measurement(sensor: .Accelerometer, date: Date(), time: 0, axisValues: [])
    
    private var selectedSensor: Sensor {
        return measurementView.selectedSensor
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = measurementView
        configureNavigationBar()
        configureViewButtonActions()
    }
    
    init(dataManagers: [any MeasurementDataHandleable]) {
        self.dataManagers = dataManagers
        
        super.init(nibName: nil, bundle: nil)
    }
    
    private func measure() {
        measurement = Measurement(sensor: selectedSensor, date: Date(), time: 0, axisValues: [])
        clearGraph()
        
        sensorManager.measure(sensor: selectedSensor, interval: 0.1, timeout: 600) { [weak self] axisValue in
            guard let axisValue else {
                self?.stop()
                return
            }
            
            self?.measurement.axisValues.append(axisValue)
            self?.drawGraph(with: axisValue)
        }
        
        setDisabledUserInteraction()
    }
    
    private func saveSensorData() {
        setDisabledUserInteraction()

        guard !measurement.axisValues.isEmpty else {
            UIAlertController.show(title: "Error",
                                   message: DataHandleError.noDataError(detail:"측정값이 없습니다.").localizedDescription,
                                   target: self)
            setEnabledUserInteraction()

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
                    try manager.saveData(self.measurement)
                }
            } catch {
                DispatchQueue.main.async {
                    UIAlertController.show(title: "Error",
                                           message: DataHandleError.saveFailError(error: error).localizedDescription,
                                           target: self)
                }
            }
            
            completion()
        }
    }
    
    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: NavigationBar
extension MeasurementViewController {
    
    private func configureNavigationBar() {
        let saveAction = UIAction { [weak self] _ in
            self?.saveSensorData()
        }
        
        let saveButton = UIBarButtonItem(title: "저장", primaryAction: saveAction)
        
        navigationItem.title = "측정하기"
        navigationItem.rightBarButtonItem = saveButton
    }
}

// MARK: ButtonAction
extension MeasurementViewController {
    
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
    
    private func stop() {
        sensorManager.stop { [weak self] _ in
            self?.setEnabledUserInteraction()
            self?.updateMeasurementData()
        }
    }
    
    private func updateMeasurementData() {
        measurement.time = 0.1 * Double(measurement.axisValues.count)
    }
}

// MARK: UserInteraction
extension MeasurementViewController {
    
    private func setDisabledUserInteraction() {
        measurementView.setDisabledSegments()
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    private func setEnabledUserInteraction() {
        measurementView.setEnabledSegments()
        navigationItem.rightBarButtonItem?.isEnabled = true
    }
}

// MARK: Draw Graph
extension MeasurementViewController {
    
    private func drawGraph(with axisValue: AxisValue) {
        measurementView.drawGraph(with: axisValue)
    }
    
    private func clearGraph() {
        measurementView.clearGraph()
    }
}

// MARK: Indicator
extension MeasurementViewController {
    
    private func startActivityIndicator() {
        self.measurementView.startActivityIndicator()
    }
    
    private func stopActivityIndicator() {
        DispatchQueue.main.async {
            self.measurementView.stopActivityIndicator()
        }
    }
}
