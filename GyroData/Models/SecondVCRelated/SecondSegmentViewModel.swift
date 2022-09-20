//
//  SecondSegmentViewModel.swift
//  GyroData
//
//  Created by pablo.jee on 2022/09/20.
//

import Foundation

class SecondSegmentViewModel {
    
    //input
    var didSegmentChange: () -> () = { }
    
    //output
    
    
    //properties
    
    init() {
        bind()
    }
    
    private func bind() {
        didSegmentChange = { [weak self] in
            guard let self = self else { return }
            print("didSegmentChange")
        }
    }
}
