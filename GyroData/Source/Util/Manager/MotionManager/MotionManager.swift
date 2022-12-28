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
    
    // 측정은 인터벌 설정한 시간마다 동작, 그 후 그래프 뷰에 넘기고 그리는건 비동기
    func startRecording(type: SensorType, completion: @escaping (MeasureData) -> Void) {
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
    
    func stopRecording(type: SensorType) {
        switch type {
        case .gyro:
            motionManager.stopGyroUpdates()
        case .acc :
            motionManager.stopAccelerometerUpdates()
        }
    }
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

// TODO: 파일 분리 필요
// 측정 데이터를 소수점 3자리로 변경하는 extension
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

