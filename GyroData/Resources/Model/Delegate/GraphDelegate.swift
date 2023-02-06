//
//  GraphDelegate.swift
//  GyroData
//
//  Created by Mangdi on 2023/02/05.
//

import Foundation

protocol GraphDelegate: AnyObject {
    func checkTime(time: Double)
    var isCheckFinish: Bool { get set }
}
