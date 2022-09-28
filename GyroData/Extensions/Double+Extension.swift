//
//  Double+Extension.swift
//  GyroData
//
//  Created by 한경수 on 2022/09/28.
//

import Foundation
import UIKit
import SwiftUI

extension Double {
    func roundUpTo(decimalPlaces: Int) -> String {
        return String(format: "%.\(decimalPlaces)f", self)
    }
}

extension Float {
    func roundUpTo(decimalPlaces: Int) -> String {
        return String(format: "%.\(decimalPlaces)f", self)
    }
}

extension CGFloat {
    func roundUpTo(decimalPlaces: Int) -> String {
        return String(format: "%.\(decimalPlaces)f", self)
    }
}
