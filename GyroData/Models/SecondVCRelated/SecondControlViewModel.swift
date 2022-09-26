//
//  SecondControlViewModel.swift
//  GyroData
//
//  Created by CodeCamper on 2022/09/26.
//

import Foundation

class SecondControlViewModel {
    // MARK: Input
    var didTapMeasureButton: () -> () = { }
    var didTapStopButton: () -> () = { }
    
    // MARK: Output
    var propagateDidTapMeasureButton: () -> () = { }
    var propagateDidTapStopButton: () -> () = { }
    
    // MARK: Properties
    
    // MARK: Init
    init() {
        bind()
    }
    
    // MARK: Bind
    func bind() {
        didTapMeasureButton = { [weak self] in
            self?.propagateDidTapMeasureButton()
        }
        
        didTapStopButton = { [weak self] in
            self?.propagateDidTapStopButton()
        }
    }
}
