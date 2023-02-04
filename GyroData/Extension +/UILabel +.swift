//
//  UILabel +.swift
//  GyroData
//
//  Created by 써니쿠키 on 2023/01/30.
//

import UIKit

extension UILabel {
    
    convenience init(text: String = "",
                     font: UIFont.TextStyle = .body,
                     textColor: UIColor = .label,
                     textAlignment: NSTextAlignment = .natural) {
        self.init(frame: .zero)
        self.text = text
        self.font = .preferredFont(forTextStyle: font)
        self.textColor = textColor
        self.textAlignment = textAlignment
        translatesAutoresizingMaskIntoConstraints = false
    }
}
