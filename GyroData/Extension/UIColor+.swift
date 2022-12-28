//
//  UIColor+.swift
//  GyroData
//
//  Created by unchain, Ellen J, yeton on 2022/12/28.
//

import UIKit

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1.0) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: a)
    }
}
