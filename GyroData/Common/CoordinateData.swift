//
//  CoordinateData.swift
//  GyroData
//
//  Created by ash and som on 2023/01/31.
//

import UIKit

enum CoordinateData: Int, CaseIterable {
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
