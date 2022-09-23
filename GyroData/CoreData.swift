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
//    static func == (lhs: RunDataList, rhs: RunDataList) -> Bool {
//
//    }
    
    let timestamp: String
    let type: String   //[Acc]
    let interval: Float
}

class Acc: Codable {
    let x: Float
    let y: Float
    let z: Float
    
    init(x: Float, y: Float, z: Float) {
        self.x = x
        self.y = y
        self.z = z
    }
}

class Gyro {
    let x: Float
    let y: Float
    let z: Float
    
    init(x: Float, y: Float, z: Float) {
        self.x = x
        self.y = y
        self.z = z
    }
}

