//
//  Styling.swift
//  GyroData
//
//  Created by pablo.jee on 2022/09/20.
//
//testteesttest
import Foundation
import UIKit

protocol BasicNavigationBarStyling { }

extension BasicNavigationBarStyling {
    var navigationBarStyle: (UINavigationBar) -> () {
        {
            $0.tintColor = .red //backbutton color
            $0.barTintColor = .black //default: nil //navi bar tintcolor //스크롤 아래로 하다 보면 색이 드러남
            $0.shadowImage = UIImage() //default: nil
            $0.prefersLargeTitles = true
            $0.isTranslucent = true
            $0.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black]
            $0.titleTextAttributes = [.foregroundColor : UIColor.white]
            $0.backgroundColor = .white //navi bar backgroundcolor // 처음 네비컨, 뷰컨 init 했을시 보이는 네비바 색
        }
    }
}

protocol FirstViewStyling { }

extension FirstViewStyling {
    var measureButtonStyling: (UIButton) -> () {
        {
            $0.setTitle("측정", for: .normal)
            $0.setTitleColor(.red, for: .normal)
        }
    }
    
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

extension NSCoding where Self: UIView {
    
    @discardableResult
    func addStyles(style: (Self) -> ()) -> Self {
        style(self)
        return self
    }
}
