//  GyroData - Array+Extension.swift
//  Created by zhilly, woong on 2023/02/04

extension Array {
    public subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
