//
//  Observable.swift
//  GyroData
//
//  Created by brad on 2022/12/29.
//

class Observable<T> {

    private var listener: ((T) -> Void)?
    
    var value : T {
        didSet {
            self.listener?(value)
        }
    }
    
    init(_ value : T) {
        self.value = value
    }
    
    func bind(_ closure: @escaping (T) -> Void) {
        closure(value)
        self.listener = closure
    }
}
