//
//  UIStackView+Extension.swift
//  GyroData
//
//  Created by 권준상 on 2022/09/27.
//

import UIKit.UIStackView

extension UIStackView {
    func addArrangedSubviews(_ views: UIView...) {
        views.forEach { addArrangedSubview($0) }
    }
}
