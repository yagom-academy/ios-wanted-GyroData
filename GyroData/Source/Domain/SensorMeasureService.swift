//
//  SensorMeasureService.swift
//  GyroData
//
//  Created by 이정민 on 2023/02/01.
//

import Foundation
protocol MeasureDelegate: AnyObject {
    typealias Values = (x: Double, y: Double, z: Double)
    
    func nonAccelerometerMeasurable()
    func nonGyroscopeMeasurable()
    
    func updateData(_ data: [Values])
}
