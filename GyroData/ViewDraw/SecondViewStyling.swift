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
            $0.backgroundColor = .grayFourth
            $0.insertSegment(withTitle: "gyro", at: 0, animated: true)
            $0.insertSegment(withTitle: "acc", at: 1, animated: true)
            $0.setEnabled(true, forSegmentAt: 0)
            $0.selectedSegmentTintColor = .white
        }
    }
    
    var controlStackViewStyling: (UIStackView) -> () {
        {
            $0.axis = .horizontal
            $0.distribution = .fillEqually
            $0.spacing = 16
        }
    }
    
    var measureButtonStyling: (UIButton) -> () {
        {
            $0.configuration = .plain()
            $0.configuration?.contentInsets = .zero
            $0.configuration?.title = "측정"
            $0.configuration?.background.backgroundColor = .grayPrimary
            $0.configuration?.baseForegroundColor = .white
        }
    }
    
    var stopButtonStyling: (UIButton) -> () {
        {
            $0.configuration = .plain()
            $0.configuration?.contentInsets = .zero
            $0.configuration?.title = "정지"
            $0.configuration?.background.backgroundColor = .grayFourth
            $0.configuration?.baseForegroundColor = .graySecondary
        }
    }
}
