//
//  MeasurementButton.swift
//  GyroData
//
//  Created by Judy on 2022/12/30.
//

import UIKit

final class MeasurementButton: UIButton {
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                self.backgroundColor = .systemGray6
            } else {
                self.backgroundColor = .systemBackground
            }
        }
    }
    
    init(title: String, frame: CGRect) {
        super.init(frame: frame)
        self.setTitle(title, for: .normal)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButton() {
        self.setTitleColor(.black, for: .normal)
        self.contentHorizontalAlignment = .left
        self.titleLabel?.font = .preferredFont(forTextStyle: .title2)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
