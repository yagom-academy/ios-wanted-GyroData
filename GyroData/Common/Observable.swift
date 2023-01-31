//
//  Observable.swift
//  GyroData
//
//  Created by ash and som on 2023/01/31.
//

import Foundation

final class Observable<T> {
    typealias Listener = ((T?) -> Void)
    
    var value: T? {
        didSet {
            listener?(value)
        }
    }
    
    init(value: T?) {
        self.value = value
    }
    
    private var listener: Listener?
    
    func bind(_ listener: @escaping Listener) {
        listener(value)
        self.listener = listener
    }
}
