//
//  MeasureViewModel.swift
//  GyroData
//
//  Created by Kyo, JPush on 2023/01/31.
//

import Foundation

final class MeasureViewModel {
    typealias Values = (x: Double, y: Double, z: Double)
    
    enum Action {
        case mesureStartButtonTapped
        case measureEndbuttonTapped
        case saveButtonTapped
        case sensorTypeChanged(sensorType: Sensor?)
    }
    
    private var sensorMeasureValues: Values = (0, 0, 0) {
        didSet {
            delegate?.updateValue(sensorMeasureValues)
        }
    }
    
    private var wasteTime: TimeInterval = .zero {
        didSet {
            delegate?.activeSave()
        }
    }
    
    private var xValues: [Double] = []
    private var yValues: [Double] = []
    private var zValues: [Double] = []
    private var startDate: Date = .init()
    private var sensorType: Sensor?
    
    private let transactionSevice: TransactionService
    private let measureService: SensorMeasureService
    
    weak var delegate: MeasureViewDelegate?
    weak var alertDelegate: AlertPresentable?
    
    init(measureService: SensorMeasureService, transactionService: TransactionService) {
        self.measureService = measureService
        self.transactionSevice = transactionService
        setDelegate()
    }
    
    func action(_ action: Action) {
        switch action {
        case .mesureStartButtonTapped:
            guard let sensorType = sensorType else { return }
            startDate = Date()
            measureService.measureStart(startDate, sensorType, interval: 0.1, duration: 60)
        case .measureEndbuttonTapped:
            measureService.measureStop()
        case .saveButtonTapped:
            saveMeasureData()
        case .sensorTypeChanged(sensorType: let sensorType):
            self.sensorType = sensorType
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
                if let coreDataError = error as? CoreDataError {
                    self.alertDelegate?.presentErrorAlert(
                        title: "오류발생",
                        message: coreDataError.errorDescription ?? ""
                    )
                    return
                } else if let fileError = error as? FileSystemError {
                    self.alertDelegate?.presentErrorAlert(
                        title: "오류발생",
                        message: fileError.errorDescription ?? ""
                    )
                    return
                }
                self.alertDelegate?.presentErrorAlert(
                    title: "오류발생",
                    message: error.localizedDescription
                )
            }
        }
    }
    
    func setDelegate() {
        self.measureService.delegate = self
    }
}

extension MeasureViewModel: MeasureServiceDelegate {
    func nonAccelerometerMeasurable() {
        alertDelegate?.presentErrorAlert(title: "센서 에러", message: "가속도 센서 사용 불가")
    }
    
    func nonGyroscopeMeasurable() {
        alertDelegate?.presentErrorAlert(title: "센서 에러", message: "자이로 센서 사용 불가")
    }
    
    func updateData(_ data: Values) {
        xValues.append(data.x)
        yValues.append(data.y)
        zValues.append(data.z)
        sensorMeasureValues = data
    }
    
    func endMeasuringData(_ wasteTime: TimeInterval) {
        self.wasteTime = wasteTime
        delegate?.endMeasuringData()
    }
}
