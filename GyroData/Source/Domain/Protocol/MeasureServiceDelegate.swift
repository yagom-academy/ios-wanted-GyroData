//
//  MeasureServiceDelegate.swift
//  GyroData
//
//  Created by 이정민 on 2023/02/02.
//

import Foundation

protocol MeasureServiceDelegate: AnyObject {
    typealias Values = (x: Double, y: Double, z: Double)
    
    func nonAccelerometerMeasurable()
    func nonGyroscopeMeasurable()
    
    func updateData(_ data: Values)
    func endMeasuringData()
    func emitWasteTime(_ wasteTime: TimeInterval)
}
