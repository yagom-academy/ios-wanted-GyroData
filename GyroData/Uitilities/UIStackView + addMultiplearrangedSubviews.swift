//
//  UIStackView + addMultiplearrangedSubviews.swift
//  GyroData
//
//  Copyright (c) 2023 Jeremy All rights reserved.
    

import UIKit

extension UIStackView {
    func addMultipleArrangedSubviews(views: [UIView]) {
        views.forEach { self.addArrangedSubview($0) }
    }
}
