//
//  PlayViewDelegate.swift
//  GyroData
//
//  Created by 이정민 on 2023/02/03.
//

protocol PlayViewDelegate: AnyObject {
    typealias Values = (x: Double, y: Double, z: Double)
    
    func playGraphView(_ data: [Values])
    func stopGraphView()
}
