//
//  UIComponent+Extension.swift
//  GyroData
//
//  Created by Kyo, JPush on 2023/02/01.
//

import UIKit

extension UILabel {
    convenience init(textStyle: UIFont.TextStyle) {
        self.init()
        font = .preferredFont(forTextStyle: textStyle)
        translatesAutoresizingMaskIntoConstraints = false
    }
}
