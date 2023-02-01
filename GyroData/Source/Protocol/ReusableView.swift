//  GyroData - ReusableView.swift
//  Created by zhilly, woong on 2023/01/31

import UIKit.UIView

protocol ReusableView: UIView {
    static var reuseIdentifier: String { get }
}

extension ReusableView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
