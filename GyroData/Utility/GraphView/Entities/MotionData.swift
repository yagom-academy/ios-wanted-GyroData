//
//  GraphData.swift
//  GyroData
//
//  Created by 김주영 on 2022/12/29.
//

import UIKit

enum MotionData: Int, CaseIterable {
    case x, y, z
    
    var color: CGColor {
        switch self {
        case .x:
            return UIColor.systemRed.cgColor
        case .y:
            return UIColor.systemGreen.cgColor
        case .z:
            return UIColor.systemBlue.cgColor
        }
    }
}
