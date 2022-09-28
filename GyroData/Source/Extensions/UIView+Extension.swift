//
//  UIView+Extension.swift
//  GyroData
//
//  Created by 권준상 on 2022/09/27.
//

import UIKit.UIView

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
}
