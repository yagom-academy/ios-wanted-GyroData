//
//  Styling.swift
//  GyroData
//
//  Created by pablo.jee on 2022/09/20.
//

import Foundation
import UIKit

protocol BasicNavigationBarStyling { }

extension BasicNavigationBarStyling {
    var navigationBarStyle: (UINavigationBar) -> () {
        {
            $0.shadowImage = UIImage() //default: nil
            $0.isTranslucent = true
            $0.titleTextAttributes = [.foregroundColor : UIColor.black]
        }
    }
}

protocol Styleable { }

extension UIView: Styleable { }
extension UIBarButtonItem: Styleable { }
extension UINavigationItem: Styleable { }

extension Styleable {
    @discardableResult
    func addStyles(style: (Self) -> ()) -> Self {
        style(self)
        return self
    }
}
