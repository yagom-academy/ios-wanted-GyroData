//
//  PageType.swift
//  GyroData
//
//  Created by 리지 on 2023/06/14.
//

enum PageType: CustomStringConvertible {
    case view
    case play
    
    var description: String {
        switch self {
        case .view:
            return "View"
        case .play:
            return "Play"
        }
    }
}
