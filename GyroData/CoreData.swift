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
    let timestamp: String
    let gyro: String
    let interval: Double
}
