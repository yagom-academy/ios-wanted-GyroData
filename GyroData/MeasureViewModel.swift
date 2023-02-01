//  GyroData - MeasureViewModel.swift
//  Created by zhilly, woong on 2023/02/01

import Foundation

class MeasureViewModel {
    var measureDatas: Observable<[MeasureData]> = Observable([])
    let coreMotionManager = CoreMotionManager()
    
    func startMeasure() {
        coreMotionManager.startGyros { [weak self] data in
            self?.measureDatas.value.append(data)
        }
    }
    
    func stopMeasure() {
        coreMotionManager.stopGyros()
    }
}
