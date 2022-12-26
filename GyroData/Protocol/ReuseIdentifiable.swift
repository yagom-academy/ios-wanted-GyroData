//
//  ReuseIdentifiable.swift
//  GyroData
//
//  Created by 백곰,바드 on 2022/12/26.
//

import UIKit

protocol ReuseIdentifiable {
    static var identifier: String { get }
}

extension ReuseIdentifiable {
    static var identifier: String {
        return String(describing: Self.self)
    }
}

extension UITableViewCell: ReuseIdentifiable { }
