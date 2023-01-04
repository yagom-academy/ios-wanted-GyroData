//
//  NSObject+extension.swift
//  GyroData
//
//  Created by Ari on 2022/12/27.
//

import Foundation

extension NSObject {

    var className: String {
        return String(describing: type(of: self))
    }

    class var className: String {
        return String(describing: self)
    }

}
