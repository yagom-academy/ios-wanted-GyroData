//
//  ThirdViewStyling.swift
//  GyroData
//
//  Created by 한경수 on 2022/09/21.
//

import Foundation
import UIKit

protocol ThirdViewStyling { }

extension ThirdViewStyling {
    var backButtonStyling: (UIBarButtonItem) -> () {
        {
            $0.image = UIImage(systemName: "chevron.left")
            $0.tintColor = .black
        }
    }
    
    var dateLabelStyling: (UILabel) -> () {
        {
            $0.textColor = .graySecondary
            $0.font = .appleSDGothicNeo(weight: .medium, size: 12)
            $0.text = Date().asString(.forDisplay)
        }
    }
    
    var typeLabelStyling: (UILabel) -> () {
        {
            $0.textColor = .grayPrimary
            $0.font = .appleSDGothicNeo(weight: .semiBold, size: 28)
        }
    }
    
    var controlButtonStyling: (UIButton) -> () {
        {
            $0.configuration = .plain()
            $0.configuration?.contentInsets = .zero
        }
    }
    
    var timerLabelStying: (UILabel) -> () {
        {
            $0.textColor = .grayPrimary
            $0.font = .appleSDGothicNeo(weight: .regular, size: 28)
        }
    }
}
