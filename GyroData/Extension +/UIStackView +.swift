//
//  UIStackView +.swift
//  GyroData
//
//  Created by 써니쿠키 on 2023/01/30.
//

import UIKit

extension UIStackView {
    
    convenience init(axis: NSLayoutConstraint.Axis = .horizontal,
                     distribution: UIStackView.Distribution = .fill,
                     alignment: UIStackView.Alignment = .fill,
                     spacing: CGFloat = 0,
                     margin: CGFloat = .zero) {
        self.init(frame: .zero)
        self.axis = axis
        self.distribution = distribution
        self.alignment = alignment
        self.spacing = spacing
        self.layoutMargins = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
        translatesAutoresizingMaskIntoConstraints = false
        
        if layoutMargins != .zero {
            isLayoutMarginsRelativeArrangement = true
        }
    }
}
