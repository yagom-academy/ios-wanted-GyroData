//
//  MeasureServiceDelegate.swift
//  GyroData
//
//  Created by Kyo, JPush on 2023/02/02.
//

import Foundation

protocol MeasureServiceDelegate: AnyObject {
    typealias Values = (x: Double, y: Double, z: Double)
    
    func nonAccelerometerMeasurable()
    func nonGyroscopeMeasurable()
    
    func updateData(_ data: Values)
    func endMeasuringData(_ wasteTime: TimeInterval)
}
