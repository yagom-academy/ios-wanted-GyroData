//
//  UIImage+Extension.swift
//  GyroData
//
//  Created by 백곰, 바드 on 2022/12/27.
//

import UIKit.UIImage

extension UIImage {
    convenience init?(view: UIView) {
        let renderer = UIGraphicsImageRenderer(bounds: view.bounds)
        let image = renderer.image { rendererContext in
            view.layer.render(in: rendererContext.cgContext)
        }

        if let cgImage = image.cgImage {
            self.init(cgImage: cgImage, scale: UIScreen.main.scale, orientation: .up)
        } else {
            return nil
        }
    }
}
