//
//  CustomSegmentedControl.swift
//  GyroData
//
//  Created by 백곰, 바드 on 2022/12/27.
//

import UIKit

final class CustomSegmentedControl: UISegmentedControl {
    
    // MARK: - Initializers
    override init(items: [Any]?) {
        super.init(items: items)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    // MARK: - Methods
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 0
        clipsToBounds = true
        layer.borderWidth = 2
    }
    
    private func commonInit() {
        setupTranslatesAutoresizingMaskIntoConstraints(false)
        backgroundColor = .white
        selectedSegmentTintColor = UIColor(named: "SelectedColor")
        selectedSegmentIndex = 0
    }
    
    private func setupTranslatesAutoresizingMaskIntoConstraints(_ bool: Bool) {
        translatesAutoresizingMaskIntoConstraints = bool
    }
}
