//
//  ReplayType.swift
//  GyroData
//
//  Created by 신병기 on 2022/09/27.
//

import Foundation

enum ReplayType {
    case view
    case replay
    
    var typeString: String {
        switch self {
        case .view: return "View"
        case .replay: return "Play"
        }
    }
}
