//  GyroData - DetailViewMode.swift
//  Created by zhilly, woong on 2023/02/04

import Foundation

enum DetailViewMode {
    case view
    case play
}

extension DetailViewMode: CustomStringConvertible {
    var description: String {
        switch self {
        case .view:
            return "View"
        case .play:
            return "Play"
        }
    }
}
