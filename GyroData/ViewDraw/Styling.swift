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
            $0.backgroundColor = .white //navi bar backgroundcolor // 처음 네비컨, 뷰컨 init 했을시 보이는 네비바 색
        }
    }
}

protocol SecondViewStyling { }

extension SecondViewStyling {
    var segmentControlStyling: (UISegmentedControl) -> () {
        {
            $0.backgroundColor = .red
            $0.insertSegment(withTitle: "gyro", at: 0, animated: true)
            $0.insertSegment(withTitle: "acc", at: 1, animated: true)
            $0.setEnabled(true, forSegmentAt: 0)
            $0.selectedSegmentTintColor = .blue
        }
    }
}

extension NSCoding where Self: UIView {
    
    @discardableResult
    func addStyles(style: (Self) -> ()) -> Self {
        style(self)
        return self
    }
}
