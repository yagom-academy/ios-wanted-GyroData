//
//  CoreMotionManager.swift
//  GyroData
//
//  Created by minsson on 2022/12/27.
//

protocol SensorDataHandleable {
    var delegate: TickReceivable { get set }
    
    func startMeasure(of: Sensor)
    func stopMeasure()
    func deliver() -> MeasuredData
}

final class CoreMotionManager {

}
