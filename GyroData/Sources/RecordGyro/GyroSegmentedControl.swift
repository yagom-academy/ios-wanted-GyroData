//
//  GyroSegmentedControl.swift
//  GyroData
//
//  Created by kokkilE on 2023/06/13.
//

import UIKit

final class GyroSegmentedControl: UISegmentedControl {
    
    override init(items: [Any]?) {
        super.init(items: items)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        backgroundColor = .white
        selectedSegmentTintColor = UIColor(red: 0.4, green: 0.6, blue: 0.8, alpha: 1)
        
        selectedSegmentIndex = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.borderWidth = 2.0
        layer.cornerRadius = 0.0
    }
}
