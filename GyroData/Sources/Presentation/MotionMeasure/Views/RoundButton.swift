//
//  RoundButton.swift
//  GyroData
//
//  Created by 우롱차 on 2022/12/28.
//

import UIKit

final class RoundButton: UIButton {
    
    convenience init(
        backgroundColor: UIColor
    ) {
        self.init(frame: .zero)
        self.backgroundColor = backgroundColor
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.gray.cgColor
        self.clipsToBounds = true
    }
    
    override func draw(_ rect: CGRect) {
        self.layer.cornerRadius = 0.5 * self.bounds.size.width
        super.draw(rect)
    }
}
