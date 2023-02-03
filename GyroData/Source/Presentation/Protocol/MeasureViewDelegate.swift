//
//  MeasureViewDelegate.swift
//  GyroData
//
//  Created by 이정민 on 2023/02/02.
//

import Foundation

protocol MeasureViewDelegate: AnyObject {
    typealias Values = (x: Double, y: Double, z: Double)
    
    func updateValue(_ values: Values)
    func endMeasuringData()
    
    func saveSuccess()
    func saveFail(_ error: Error)
}
