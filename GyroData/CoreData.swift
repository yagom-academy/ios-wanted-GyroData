//
//  CoreData.swift
//  GyroData
//
//  Created by 1 on 2022/09/20.
//

import Foundation
import UIKit
import CoreData


struct RunDataList: Codable, Equatable {
    let uuid: Double
    let gyro: String
    let acc: String
    let timestamp: String
    let interval: Double
    //    let modelacc: [Acc]
    //    let modelgyro: [Gyro]
}
//struct Acc {
//    var x: Double
//    var y: Double
//    var z: Double
//}
//struct Gyro {
//    var x: Double
//    var y: Double
//    var z: Double
//}

