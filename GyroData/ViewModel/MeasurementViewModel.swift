//
//  MeasurementViewModel.swift
//  GyroData
//
//  Created by ash and som on 2023/01/31.
//

import Foundation

protocol MeasurementInput {
    func save(_ graphMode: GraphMode, data: [[Double]])
    func startMeasurement(_ graphMode: GraphMode, on graphView: GraphView)
    func stopMeasurement(_ graphMode: GraphMode)
}

protocol MeasurementOutput {
    var isMeasuring: Observable<Bool> { get }
    var isLoading: Observable<Bool?> { get set }
    var error: Observable<String?> { get }
}

struct MeasurementViewModel: MeasurementInput, MeasurementOutput {
    private let coreDataManager = CoreDataManager.shared
    private let fileDataManager = FileDataManager.shared
    private let measurementManager = MeasurementManager.shared

    var isMeasuring: Observable<Bool> = Observable(value: false)
    var isLoading: Observable<Bool?> = Observable(value: nil)
    var error: Observable<String?> = Observable(value: nil)
    
    func save(_ graphMode: GraphMode, data: [[Double]]) {
        guard data.isEmpty == false else { return }

        let newGyroData = GyroInformationModel(date: Date(),
                                               time: measurementManager.timeCount,
                                               graphMode: graphMode)

        saveToCoreData(newGyroData)
        saveToFile(newGyroData, data: data)
    }

    func startMeasurement(_ graphMode: GraphMode, on graphView: GraphView) {
        isMeasuring.value = true
        measurementManager.start(graphMode, graphView) {
            self.isMeasuring.value = false
        }
    }

    func stopMeasurement(_ graphMode: GraphMode) {
        isMeasuring.value = false
        measurementManager.stop(graphMode)
    }

    private func saveToCoreData(_ information: GyroInformationModel) {
        coreDataManager.save(information) { result in
            switch result {
            case .success:
                self.isLoading.value = false
            case .failure(let failure):
                self.error.value = failure.message
            }
        }
    }

    private func saveToFile(_ information: GyroInformationModel, data: [[Double]]) {
        let xData = data.map { $0[CoordinateData.x.rawValue] }
        let yData = data.map { $0[CoordinateData.y.rawValue] }
        let zData = data.map { $0[CoordinateData.z.rawValue] }
        let gyroData = GyroData(gyroInformation: information, x: xData, y: yData, z: zData)

        fileDataManager.save(data: gyroData,
                             id: information.id) { result in
            switch result {
            case .success:
                self.isLoading.value = false
            case .failure(let failure):
                self.error.value = failure.message
            }
        }
    }
}
