//
//  ReuseIdentifying.swift
//  GyroData
//
//  Created by 백곰, 바드 on 2022/12/30.
//

protocol ReuseIdentifying {
    static var reuseIdentifier: String { get }
}

extension ReuseIdentifying {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}

