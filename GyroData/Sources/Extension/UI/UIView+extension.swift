//
//  UIView+extension.swift
//  GyroData
//
//  Created by Ari on 2022/12/27.
//

import UIKit

extension UIView {
    
    func addSubviews(_ views: UIView...) {
        views.forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
        }
    }
    
}
