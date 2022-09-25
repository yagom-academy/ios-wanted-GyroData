//
//  CustomButton.swift
//  GyroData
//
//  Created by 신동원 on 2022/09/25.
//

import UIKit

class CustomButton: UIButton {
    override var isEnabled: Bool {
        didSet {
            if isEnabled {
                self.setTitleColor(UIColor.systemBlue, for: .normal)
            } else {
                self.setTitleColor(UIColor.systemGray, for: .normal)
            }
        }
    }
}
