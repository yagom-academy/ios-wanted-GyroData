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
    
    private var sensorMeasureValues: Values = (0, 0, 0) {
        didSet {
            delegate?.updateValue(sensorMeasureValues)
        }
    }
    
    private var xValues: [Double] = []
    private var yValues: [Double] = []
    private var zValues: [Double] = []
    private var startDate: Date = .init()
    private var wasteTime: TimeInterval = .zero
    private var sensorType: Sensor?
    
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
            startDate = Date()
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
        let measureData = MeasureData(
            xValue: xValues,
            yValue: yValues,
            zValue: zValues,
            runTime: wasteTime,
            date: startDate,
            type: sensorType
        )
        
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
        xValues.append(data.x)
        yValues.append(data.y)
        zValues.append(data.z)
        sensorMeasureValues = data
    }
    
    func endMeasuringData() {
        delegate?.endMeasuringData()
    }
    
    func emitWasteTime(_ wasteTime: TimeInterval) {
        self.wasteTime = wasteTime
    }
}
