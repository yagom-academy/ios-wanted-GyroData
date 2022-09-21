//
//  UIView+Extenstion.swift
//  GyroData
//
//  Created by 김지인 on 2022/09/21.
//

import UIKit.UIView

extension UIView {
    func addSubViews(_ views: UIView...) {
        views.forEach(self.addSubview(_:))
    }
}
