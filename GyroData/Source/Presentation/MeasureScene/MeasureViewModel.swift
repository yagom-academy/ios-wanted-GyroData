//
//  MeasureViewModel.swift
//  GyroData
//
//  Created by Kyo, JPush on 2023/01/31.
//

import Foundation

class MeasureViewModel {
    typealias Values = (x: Double, y: Double, z: Double)
    
    enum Action {
        case mesureStartButtonTapped(sensorType: Sensor)
        case measureEndbuttonTapped
        case saveButtonTapped
    }
    
    private var measureData: MeasureData {
        didSet {
            if let xValue = measureData.xValue.last,
               let yValue = measureData.yValue.last,
               let zValue = measureData.zValue.last {
                
                let lastData: Values = (xValue, yValue, zValue)
                delegate?.updateValue(lastData)
            }
        }
    }
    private let transactionSevice = TransactionService(
        coreDataManager: CoreDataManager(),
        fileManager: FileSystemManager()
    )
    private let measureService: SensorMeasureService
    private weak var delegate: MeasureViewDelegate?
    
    init(delegate: MeasureViewDelegate, measureService: SensorMeasureService) {
        self.delegate = delegate
        self.measureService = measureService
    }
    
    func action(_ action: Action) {
        switch action {
        case .mesureStartButtonTapped(sensorType: let sensorType):
            measureService.measureStart(sensorType, interval: 0.1, duration: 60)
        case .measureEndbuttonTapped:
            measureService.measureStop()
        case .saveButtonTapped:
            saveMeasureData()
        }
    }
}

private extension MeasureViewModel {
    func saveMeasureData() {
        transactionSevice.save(data: measureData) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                self.delegate?.saveSuccess()
            case .failure(let error):
                self.delegate?.saveFail(error)
            }
        }
    }
}

extension MeasureViewModel: MeasureServiceDelegate {
    func nonAccelerometerMeasurable() {
        delegate?.nonAccelerometerMeasurable()
    }
    
    func nonGyroscopeMeasurable() {
        delegate?.nonGyroscopeMeasurable()
    }
    
    func updateData(_ data: Values) {
        self.measureData.xValue.append(data.x)
        self.measureData.yValue.append(data.y)
        self.measureData.zValue.append(data.z)
    }
    
    func endMeasuringData() {
        delegate?.endMeasuringData()
    }
}
