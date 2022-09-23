//
//  UIModule.swift
//  GyroData
//
//  Created by KangMingyo on 2022/09/21.
//

import Foundation

// sample struct
struct gyroValue {
    let x: Float
    let y: Float
    let z: Float

    init(x: Float, y: Float, z: Float) {
        self.x = x
        self.y = y
        self.z = z
    }
}
//
//// sample data
//while graphData.count <= 600 {
//    let x = Float.random(in: -100.0 ..< -70.0)
//    let y = Float.random(in: -20.0 ..< 30.0)
//    let z = Float.random(in: 60.0 ..< 100.0)
//    graphData.append(gyroValue(x: x, y: y, z: z))
//}
