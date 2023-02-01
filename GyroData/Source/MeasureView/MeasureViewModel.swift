//  GyroData - MeasureViewModel.swift
//  Created by zhilly, woong on 2023/02/01

import Foundation

final class MeasureViewModel {
    var measureDatas: Observable<[MeasureData]> = Observable([MeasureData(x: 0, y: 0, z: 0)])
    private let coreMotionManager = CoreMotionManager()
    
    func startMeasure(mode: SensorMode) {
        switch mode {
        case .Gyro:
            coreMotionManager.startGyros { [weak self] data in
                self?.measureDatas.value.append(data)
                print("startGyros")
                print(data)
            }
        case .Acc:
            coreMotionManager.startAccelerometers { [weak self] data in
                self?.measureDatas.value.append(data)
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
