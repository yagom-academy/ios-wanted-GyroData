//
//  CoreMotionManager.swift
//  GyroData
//
//  Created by Brad on 2022/12/27.
//

import Foundation
import CoreMotion

protocol SensorDataHandleable {
    var delegate: TickReceivable? { get set }
    
    func startMeasure(of: Sensor)
    func stopMeasure()
    func deliverMeasureData() -> MeasuredData
}

final class CoreMotionManager: SensorDataHandleable {
    private let motionManager = CMMotionManager()
    
    var delegate: TickReceivable?
    
    private var timer: Timer?
    private var timerNum: Double = 0.0
    private let timeSet: Double = 60.0
    private var senser: Sensor = Sensor.accelerometer
    private var sensorData: [SensorData] = []
    private var axisX: [Double] = []
    private var axisY: [Double] = []
    private var axisZ: [Double] = []
    
    init() {
        setupMotionInterval()
    }
    
    func startMeasure(of SensorType: Sensor) {
        
        if timer != nil && timer!.isValid {
            timer!.invalidate()
        }
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { _ in
            self.timerNum += 0.1
            }
        )
        switch SensorType {
        case .gyro:
            senser = SensorType
            motionManager.startGyroUpdates(to: OperationQueue.current!) { (data, error) in
                if let myData = data {
                    self.axisX.append(myData.rotationRate.x.axisDecimal())
                    self.axisY.append(myData.rotationRate.y.axisDecimal())
                    self.axisZ.append(myData.rotationRate.z.axisDecimal())
                    
                    self.delegate?.receive(
                        x: myData.rotationRate.x.axisDecimal(),
                        y: myData.rotationRate.y.axisDecimal(),
                        z: myData.rotationRate.z.axisDecimal()
                    )
                }
                if self.timerNum.timeDecimal() == self.timeSet {
                    self.stopMeasure()
                }
            }
        case .accelerometer:
            senser = SensorType
            motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (data, error) in
                if let myData = data {
                    self.axisX.append(myData.acceleration.x.axisDecimal())
                    self.axisY.append(myData.acceleration.y.axisDecimal())
                    self.axisZ.append(myData.acceleration.z.axisDecimal())
                    
                    self.delegate?.receive(
                        x: myData.acceleration.x.axisDecimal(),
                        y: myData.acceleration.y.axisDecimal(),
                        z: myData.acceleration.z.axisDecimal()
                    )
                }
                if self.timerNum.timeDecimal() == self.timeSet {
                    self.stopMeasure()
                }
            }
        }

    }
    
    func stopMeasure() {
        timer?.invalidate()
        motionManager.stopGyroUpdates()
        motionManager.stopAccelerometerUpdates()
    }
    
    func deliverMeasureData() -> MeasuredData {
        let mesuredData = MeasuredData(
            uuid: UUID(),
            date: Date(),
            measuredTime: timerNum.timeDecimal(),
            sensor: senser,
            sensorData: SensorData(
                axisX: self.axisX,
                axisY: self.axisY,
                axisZ: self.axisZ
            )
        )
        timerNum = 0
        return mesuredData
    }
}

private extension CoreMotionManager {
    
    private func setupMotionInterval() {
        motionManager.gyroUpdateInterval = 1/60
        motionManager.accelerometerUpdateInterval = 1/60
    }
}

