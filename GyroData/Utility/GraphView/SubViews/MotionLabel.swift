//
//  MotionLabel.swift
//  GyroData
//
//  Created by Judy on 2022/12/29.
//

import UIKit

class MotionLabel: UILabel {
    init(textColor: UIColor, frame: CGRect) {
        super.init(frame: frame)
        setupLabel()
        self.textColor = textColor
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLabel()
    }
    
    private func setupLabel() {
        self.text = String(Double.zero)
        self.textAlignment = .center
        self.font = .preferredFont(forTextStyle: .body)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
