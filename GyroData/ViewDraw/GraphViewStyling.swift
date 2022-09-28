//
//  GraphViewStyling.swift
//  GyroData
//
//  Created by 한경수 on 2022/09/28.
//

import Foundation
import UIKit

protocol GraphViewStyling { }

extension GraphViewStyling {
    var graphMaxLabelStyling: (UILabel) -> () {
        {
            $0.font = .appleSDGothicNeo(weight: .bold, size: 16)
            $0.textColor = .gray
        }
    }
    
    var stackViewStyling: (UIStackView) -> () {
        {
            $0.axis = .horizontal
            $0.distribution = .fillEqually
        }
    }
    
    var xMaxLabelStyling: (UILabel) -> () {
        {
            $0.font = .appleSDGothicNeo(weight: .regular, size: 10)
            $0.textColor = .red
        }
    }
    
    var yMaxLabelStyling: (UILabel) -> () {
        {
            $0.font = .appleSDGothicNeo(weight: .regular, size: 10)
            $0.textColor = .green
        }
    }
    
    var zMaxLabelStyling: (UILabel) -> () {
        {
            $0.font = .appleSDGothicNeo(weight: .regular, size: 10)
            $0.textColor = .blue
        }
    }
}
