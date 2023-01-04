//
//  Observable.swift
//  GyroData
//
//  Created by TORI on 2022/12/30.
//

import Foundation

final class Observable<T> {
    
    var value: T {
        didSet {
            self.closure?(value)
        }
    }
    
    private var closure: ((T) -> Void)?
    
    init(_ value: T) {
        self.value = value
    }
    
    func subscribe(completion: @escaping (T) -> Void) {
        completion(value)
        closure = completion
    }
}
