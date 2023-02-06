//
//  Identifiable.swift
//  GyroData
//
//  Created by Kyo, JPush on 2023/02/01.
//

import Foundation

protocol Identifiable: AnyObject { }

extension Identifiable {
    static var identifier: String {
        return String.init(describing: self)
    }
}
