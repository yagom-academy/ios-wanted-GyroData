//
//  Type+extension.swift
//  GyroData
//
//  Created by dhoney96 on 2022/12/30.
//

import Foundation
import CoreMotion

protocol MeasureDataConvertProtocol {
    func convertMeasureData() -> MeasureData
}
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

extension Double {
    func roundDigit() -> Double {
        return (self * 1000).rounded() / 1000
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
