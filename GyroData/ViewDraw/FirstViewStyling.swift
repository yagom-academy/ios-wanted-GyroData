//
//  FirstViewStyling.swift
//  GyroData
//
//  Created by CodeCamper on 2022/09/21.
//

import Foundation
import UIKit

protocol FirstViewStyling { }

extension FirstViewStyling {
    var cellTimeLabelStyling: (UILabel) -> () {
        {
            $0.textColor = .graySecondary
            $0.font = .appleSDGothicNeo(weight: .regular, size: 12)
            $0.textAlignment = .left
        }
    }
    
    var cellMeasureTypelabelStyling: (UILabel) -> () {
        {
            $0.textColor = .grayPrimary
            $0.font = .appleSDGothicNeo(weight: .regular, size: 18)
            $0.textAlignment = .left
        }
    }
    
    var cellAmountTypeLabelStyling: (UILabel) -> () {
        {
            $0.textColor = .grayPrimary
            $0.font = .appleSDGothicNeo(weight: .regular, size: 28)
            $0.textAlignment = .center
        }
    }
}
