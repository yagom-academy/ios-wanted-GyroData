//
//  UIButton.swift
//  GyroData
//
//  Created by 곽우종 on 2022/12/28.
//

import UIKit

extension UIButton {
    convenience init(
        backgroundColor: UIColor,
        cornerRadius: CGFloat
    ) {
        self.init(frame: .zero)
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = cornerRadius * self.bounds.size.width
        self.clipsToBounds = true
    }
}
