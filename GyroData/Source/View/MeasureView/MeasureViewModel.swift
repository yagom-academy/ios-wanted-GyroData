//  GyroData - MeasureViewModel.swift
//  Created by zhilly, woong on 2023/02/01

import Foundation

final class MeasureViewModel {
    var measureDatas: Observable<SensorData> = .init(SensorData(x: [], y: [], z: []))

    private let coreMotionManager = CoreMotionManager()
    private let coreDataManager = CoreDataManager.shared
    
    func startMeasure(mode: SensorMode) {
        switch mode {
        case .Gyro:
            coreMotionManager.startGyros { [weak self] data in
                self?.measureDatas.value = data
            }
        case .Acc:
            coreMotionManager.startAccelerometers { [weak self] data in
                self?.measureDatas.value = data
            }
        }
    }
    
    func stopMeasure(mode: SensorMode) {
        switch mode {
        case .Gyro:
            coreMotionManager.stopGyros()
        case .Acc:
            coreMotionManager.stopAccelerometers()
        }
    }
    
    func resetMeasureDatas() {
        measureDatas.value.x.removeAll()
        measureDatas.value.y.removeAll()
        measureDatas.value.z.removeAll()
    }
}

extension MeasureViewModel {
    func add(sensorMode: SensorMode, sensorData: SensorData) {
        let data = MotionData.init(createdAt: Date(),
                                   sensorType: sensorMode,
                                   runtime: coreMotionManager.second,
                                   sensorData: sensorData)
        do {
            try coreDataManager.add(data)
        } catch {
            print(error.localizedDescription)
        }
    }
}
