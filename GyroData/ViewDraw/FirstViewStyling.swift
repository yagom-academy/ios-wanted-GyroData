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
            $0.font = UIFont.systemFont(ofSize: 12)
            $0.textColor = .black
            $0.textAlignment = .left
        }
    }
    
    var cellMeasureTypelabelStyling: (UILabel) -> () {
        {
            $0.font = UIFont.systemFont(ofSize: 12)
            $0.textColor = .black
            $0.textAlignment = .left
        }
    }
    
    var cellAmountTypeLabelStyling: (UILabel) -> () {
        {
            $0.font = UIFont.systemFont(ofSize: 16)
            $0.textColor = .black
            $0.textAlignment = .center
        }
    }
}
