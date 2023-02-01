//  GyroData - MeasureViewModel.swift
//  Created by zhilly, woong on 2023/02/01

import Foundation

enum SensorMode {
    case Gyro
    case Acc
}

class MeasureViewModel {
    var measureDatas: Observable<[MeasureData]> = Observable([])
    let coreMotionManager = CoreMotionManager()
    
    func startMeasure(mode: SensorMode) {
        switch mode {
        case .Gyro:
            coreMotionManager.startGyros { [weak self] data in
                self?.measureDatas.value.append(data)
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
