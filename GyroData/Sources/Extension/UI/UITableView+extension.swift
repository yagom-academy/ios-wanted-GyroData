//
//  UITableView+extension.swift
//  GyroData
//
//  Created by Ari on 2022/12/27.
//

import UIKit

extension UITableView {

    func register<T: UITableViewCell>(_ cellClass: T.Type) {
        let reuseIdentifier = cellClass.className
        register(cellClass, forCellReuseIdentifier: reuseIdentifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(_ cellClass: T.Type, for indexPath: IndexPath) -> T? {
        return dequeueReusableCell(withIdentifier: cellClass.className, for: indexPath) as? T
    }
    
}
