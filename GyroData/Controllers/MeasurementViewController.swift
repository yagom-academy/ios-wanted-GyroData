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
    
    private var measurementData = Measurement(sensor: .Accelerometer, date: Date(), time: 0, axisValues: [])
    private var axisValues: [AxisValue] = []
    
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
        measurementData = Measurement(sensor: selectedSensor, date: Date(), time: 0, axisValues: [])
        clearGraph()
        
        sensorManager.measure(sensor: selectedSensor, interval: 0.1, timeout: 600) { [weak self] data in
            guard let data else {
                self?.stop()
                return
            }
            
            self?.axisValues.append(data)
            self?.drawGraph(with: data)
        }
        
        setDisabledUserInteraction()
    }
    
    private func saveSensorData() {
        if measurementData.axisValues == [] {
            UIAlertController.show(title: "Error",
                                   message: DataHandleError.noDataError(detail: "측정한 데이터가 없습니다.").localizedDescription,
                                   target: self)
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
                                       message: DataHandleError.saveFailError(error: error).localizedDescription,
                                       target: self)
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
        measurementData.axisValues = axisValues
        measurementData.time = 0.1 * Double(measurementData.axisValues.count)
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
    
    private func drawGraph(with data: AxisValue) {
        measurementView.drawGraph(with: data)
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
