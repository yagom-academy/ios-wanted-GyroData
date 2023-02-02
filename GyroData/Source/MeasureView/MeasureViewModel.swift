//  GyroData - MeasureViewModel.swift
//  Created by zhilly, woong on 2023/02/01

import Foundation

final class MeasureViewModel {
    var measureDatas: Observable<SensorData> = .init(SensorData(x: [], y: [], z: []))

    private let coreMotionManager = CoreMotionManager()
    
    func startMeasure(mode: SensorMode) {
        switch mode {
        case .Gyro:
            coreMotionManager.startGyros { [weak self] data in
                self?.measureDatas.value.x = data.x
                self?.measureDatas.value.y = data.y
                self?.measureDatas.value.z = data.z
            }
        case .Acc:
            coreMotionManager.startAccelerometers { [weak self] data in
                self?.measureDatas.value.x = data.x
                self?.measureDatas.value.y = data.y
                self?.measureDatas.value.z = data.z
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
}
