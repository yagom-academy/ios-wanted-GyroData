//
//  Collection+extension.swift
//  GyroData
//
//  Created by Ari on 2022/12/27.
//

import Foundation

extension Collection {
    
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
    
}
