//
//  Styling.swift
//  GyroData
//
//  Created by pablo.jee on 2022/09/20.
//

import Foundation
import UIKit

protocol FirstViewStyling { }

extension FirstViewStyling {
    var measureButtonStyling: (UIButton) -> () {
        {
            $0.setTitle("측정", for: .normal)
            $0.setTitleColor(.red, for: .normal)
        }
    }
}

extension NSCoding where Self: UIView {
    
    @discardableResult
    func addStyle(style: (Self) -> ()) -> Self {
        style(self)
        return self
    }
}
