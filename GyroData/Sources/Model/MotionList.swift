//
//  MotionInfo.swift
//  GyroData
//
//  Created by Ari on 2022/12/27.
//

import Foundation

struct MotionList: Codable {
    
    let uuid: UUID
    let values: [MotionValue]
    
}
