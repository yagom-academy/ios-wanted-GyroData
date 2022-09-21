//
//  Extension.swift
//  GyroData
//
//  Created by 엄철찬 on 2022/09/21.
//

import Foundation
import UIKit

extension NSLayoutConstraint {
    func constraintWithMultiplier(_ multiplier:CGFloat) -> NSLayoutConstraint{
        return NSLayoutConstraint(item: self.firstItem!, attribute: self.firstAttribute, relatedBy: self.relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: multiplier, constant: self.constant)
    }
}
