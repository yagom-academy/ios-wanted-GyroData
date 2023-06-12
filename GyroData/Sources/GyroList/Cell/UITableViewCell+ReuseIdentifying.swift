//
//  UITableViewCell+ReuseIdentifying.swift
//  GyroData
//
//  Created by kokkilE on 2023/06/12.
//

import UIKit

public protocol ReuseIdentifying {}

extension ReuseIdentifying {
    public static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReuseIdentifying {}
