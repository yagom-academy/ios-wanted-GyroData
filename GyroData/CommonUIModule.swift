//
//  CommonCommonUIModule.swift
//  GyroData
//
//  Created by 유영훈 on 2022/09/21.
//

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
    
    let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .long
        f.timeStyle = .short
        f.locale = Locale(identifier: "ko_kr")
        f.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return f
    }()
}

extension Double {
    /// 자릿수 지정하여 floor(내림) 처리
    func fixed(_ decimalPoint: Int) -> Float {
        let digit: Double = pow(10, Double(decimalPoint))
        let fixedInterval = floor(self * digit) / digit
        return Float(fixedInterval)
    }
}
