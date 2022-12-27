//
//  ReplayViewType.swift
//  GyroData
//
//  Created by bonf, seohyeon2 on 2022/12/27.
//

enum ReplayViewPageType {
    case view
    case play
    
    var name: String {
        switch self {
        case .view:
            return "View"
        case .play:
            return "Play"
        }
    }
}
