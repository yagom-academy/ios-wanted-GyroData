//
//  UILabel +.swift
//  GyroData
//
//  Created by 써니쿠키 on 2023/01/30.
//

import UIKit

extension UILabel {
    
    convenience init(font: UIFont.TextStyle = .body,
                     textAlignment: NSTextAlignment = .natural) {
        self.init(frame: .zero)
        self.font = .preferredFont(forTextStyle: font)
        self.textAlignment = textAlignment
        translatesAutoresizingMaskIntoConstraints = false
    }
}
