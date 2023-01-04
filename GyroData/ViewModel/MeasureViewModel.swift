//
//  MeasureViewModel.swift
//  GyroData
//
//  Created by 이원빈 on 2022/12/29.
//

import Foundation

final class MeasureViewModel {
    
    private let coreDataManager = CoreDataManager()
    private let fileHandlerManager = FileHandleManager()
    private let coreMotionManager = CoreMotionManager()

    var myX: Double = 0.0
    var myY: Double = 0.0
    var myZ: Double = 0.0
    
    init() {
        coreDataManager.fileManager = fileHandlerManager
    }
    
    func startCoreMotion(of SensorType: Sensor) {
        coreMotionManager.startMeasure(of: SensorType) { data in
            self.myX = data.axisX[0]
            self.myY = data.axisY[0]
            self.myZ = data.axisZ[0]
        }
    }
    
    func stopCoreMotion() {
        coreMotionManager.stopMeasure()
    }
    
    func saveCoreMotion() {
        coreDataManager.create(data: coreMotionManager.deliverMeasureData())
    }
}
 
