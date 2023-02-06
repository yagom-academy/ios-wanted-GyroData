//
//  UIComponent+Extension.swift
//  GyroData
//
//  Created by Kyo, JPush on 2023/02/01.
//

import UIKit

extension UILabel {
    convenience init(textStyle: UIFont.TextStyle) {
        self.init()
        font = .preferredFont(forTextStyle: textStyle)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    convenience init(title: String, textStyle: UIFont.TextStyle, backgroundColor: UIColor) {
        self.init()
        text = title
        self.backgroundColor = backgroundColor
        font = .preferredFont(forTextStyle: textStyle)
        sizeToFit()
        translatesAutoresizingMaskIntoConstraints = false
    }
}

extension UIImage {
    convenience init?(view: UIView) {
        let renderer = UIGraphicsImageRenderer(bounds: view.bounds)
        let image = renderer.image { renderContext in
            view.layer.render(in: renderContext.cgContext)
        }
        
        if let cgImage = image.cgImage {
            self.init(cgImage: cgImage, scale: UIScreen.main.scale, orientation: .up)
        } else {
            return nil
        }
    }
}
