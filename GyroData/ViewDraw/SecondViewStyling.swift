//
//  SecondViewStyling.swift
//  GyroData
//
//  Created by CodeCamper on 2022/09/21.
//

import Foundation
import UIKit

protocol SecondViewStyling { }

extension SecondViewStyling {
    var saveButtonStyling: (UIBarButtonItem) -> () {
        {
            $0.title = "저장"
        }
    }
    
    var backButtonStyling: (UIBarButtonItem) -> () {
        {
            $0.image = UIImage(systemName: "chevron.left")
            $0.tintColor = .black
        }
    }
    
    var segmentControlStyling: (UISegmentedControl) -> () {
        {
            $0.backgroundColor = .white
            $0.insertSegment(withTitle: "gyro", at: 0, animated: true)
            $0.insertSegment(withTitle: "acc", at: 1, animated: true)
            $0.setEnabled(true, forSegmentAt: 0)
            $0.selectedSegmentTintColor = .systemCyan
        }
    }
    
    var controlStackViewStyling: (UIStackView) -> () {
        {
            $0.axis = .vertical
            $0.distribution = .equalSpacing
            $0.alignment = .leading
        }
    }
    
    var measureButtonStyling: (UIButton) -> () {
        {
            $0.configuration = .plain()
            $0.configuration?.title = "측정"
            $0.configuration?.contentInsets = .zero
        }
    }
    
    var stopButtonStyling: (UIButton) -> () {
        {
            $0.configuration = .plain()
            $0.configuration?.title = "정지"
            $0.configuration?.contentInsets = .zero
        }
    }
}
