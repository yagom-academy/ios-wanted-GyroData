//
//  MotionManager.swift
//  GyroData
//
//  Created by 유한석 on 2022/12/26.
//

import Foundation
import CoreMotion

final class MotionManager {
    
    let motionManager = CMMotionManager()
    static let shared = MotionManager()
    
    private init() {
    
    }
    
    deinit {
        self.motionManager.stopGyroUpdates()
        self.motionManager.stopAccelerometerUpdates()
    }
    
    func setupMotionManagerInterval(at interval: Double) {
        self.motionManager.gyroUpdateInterval = interval
        self.motionManager.accelerometerUpdateInterval = interval
    }
    
    func startRecording(type: TempSensorType, completion: @escaping (MeasureData) -> Void) {
        switch type {
        case .gyro:
            motionManager.startGyroUpdates(to: OperationQueue())
            { (gyroData: CMGyroData?, error: Error?) in
                guard let gyroData = gyroData else { return }
                completion(gyroData.convertMeasureData())
            }
        case .acc:
            motionManager.startAccelerometerUpdates(to: OperationQueue())
            { (accData: CMAccelerometerData?, error: Error?) in
                guard let accData = accData else { return }
                completion(accData.convertMeasureData())
            }
        }
    }
    
    func stopRecording(type: TempSensorType) {
        switch type {
        case .gyro:
            motionManager.stopGyroUpdates()
        case .acc :
            motionManager.stopAccelerometerUpdates()
        }
    }
}

// TODO: 코어 데이터 타입을 머지하기 전이라 동일한 내용의 임시 열거형 사용.
enum TempSensorType: String {
    case acc = "Accelerometer"
    case gyro = "Gyro"
}

// TODO: 파일 분리 필요
protocol MeasureDataConvertProtocol {
    func convertMeasureData() -> MeasureData
}

extension Double {
    func roundDigit() -> Double {
        return (self * 1000).rounded() / 1000
    }
}

extension CMGyroData: MeasureDataConvertProtocol {
    func convertMeasureData() -> MeasureData {
        return MeasureData(
            lotationX: self.rotationRate.x.roundDigit(),
            lotationY: self.rotationRate.y.roundDigit(),
            lotationZ: self.rotationRate.z.roundDigit()
        )
    }
}

extension CMAccelerometerData: MeasureDataConvertProtocol {
    func convertMeasureData() -> MeasureData {
        return MeasureData(
            lotationX: self.acceleration.x.roundDigit(),
            lotationY: self.acceleration.y.roundDigit(),
            lotationZ: self.acceleration.z.roundDigit()
        )
    }
}

