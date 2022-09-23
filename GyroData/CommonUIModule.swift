//
//  CommonCommonUIModule.swift
//  GyroData
//
//  Created by 유영훈 on 2022/09/21.
//

import Foundation
import UIKit

class CommonUIModule {
    func creatLabel(text: String?, color: UIColor?, alignment: NSTextAlignment?, fontSize: CGFloat?, fontWeight: UIFont.Weight?) -> UILabel {
        let label = UILabel()
        label.text = text ?? ""
        label.textAlignment = alignment ?? .center
        label.textColor = color ?? .black
        label.font = UIFont.systemFont(ofSize: fontSize ?? 15, weight: fontWeight ?? .regular)
        return label
    }
}
