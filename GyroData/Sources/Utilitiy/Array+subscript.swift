//
//  Array+subscript.swift
//  GyroData
//
//  Created by kokkilE on 2023/06/15.
//

extension Array {
    subscript (safe index: Int) -> Element? {
        get {
            return indices ~= index ? self[index] : nil
        }
        set {
            guard let newValue,
                  indices ~= index else { return }
            
            self[index] = newValue
        }
    }
}
