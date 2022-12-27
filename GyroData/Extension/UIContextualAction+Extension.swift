//
//  UIContextualAction+Extension.swift
//  GyroData
//
//  Created by 백곰, 바드 on 2022/12/27.
//

import UIKit.UIContextualAction

extension UIContextualAction {
    func makeCustomTitle(
        text: String,
        font: UIFont,
        textColor: UIColor?,
        backgroundColor: UIColor?
    ) {
        let label = UILabel()
        label.text = text
        label.font = font
        label.textColor = textColor
        label.sizeToFit()
        
        self.image = UIImage(view: label)
        self.backgroundColor = backgroundColor
    }
}
