//
//  PlayViewDelegate.swift
//  GyroData
//
//  Created by Kyo, JPush on 2023/02/03.
//

protocol PlayViewDelegate: AnyObject {
    typealias Values = (x: Double, y: Double, z: Double)
    
    func playGraphView(_ data: [Values])
    func stopGraphView()
}
