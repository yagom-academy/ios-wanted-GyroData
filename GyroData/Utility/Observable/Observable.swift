//
//  Observable.swift
//  GyroData
//
//  Created by 이호영 on 2022/12/27.
//

import Foundation

class Observable<T> {
    var value: T {
        didSet {
            self.listener?(value)
        }
    }
    
    private var listener: ((T) -> Void)?

    init(_ value: T) {
        self.value = value
    }

    func subscribe(listener: @escaping (T) -> Void) {
        listener(value)
        self.listener = listener
    }
}
