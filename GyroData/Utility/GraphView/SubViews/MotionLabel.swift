//
//  MotionLabel.swift
//  GyroData
//
//  Created by Judy on 2022/12/29.
//

import UIKit

class MotionLabel: UILabel {
    init(motionData: MotionData, frame: CGRect) {
        super.init(frame: frame)
        setupLabel(with: motionData)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLabel(with: .x)
    }
    
    private func setupLabel(with motionData: MotionData) {
        self.textAlignment = .center
        self.font = .preferredFont(forTextStyle: .body)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        switch motionData {
        case .x:
            self.textColor = .systemRed
            self.text = "x: " + String(Double.zero)
        case .y:
            self.textColor = .systemGreen
            self.text = "y: " + String(Double.zero)
        case .z:
            self.textColor = .systemBlue
            self.text = "z: " +  String(Double.zero)
        }
    }
}
