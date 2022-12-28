//
//  UIView+.swift
//  GyroData
//
//  Created by Ellen J on 2022/12/28.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
    }
}
