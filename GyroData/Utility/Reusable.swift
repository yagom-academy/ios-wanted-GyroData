//
//  Reusable.swift
//  GyroData
//
//  Created by Aaron, Gundy on 2023/01/31.
//

protocol Reusable {

    static var reuseIdentifier: String { get }
}

extension Reusable {

    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
