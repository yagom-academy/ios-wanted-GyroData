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
    var didReceiveIsMeasuring: (Bool) -> () = { isMeasuring in }
    
    // MARK: Output
    var propagateDidTapMeasureButton: () -> () = { }
    var propagateDidTapStopButton: () -> () = { }
    var isMeasuringSource: (Bool) -> () = { isMeasuring in } {
        didSet {
            isMeasuringSource(_isMeasuring)
        }
    }
    
    // MARK: Properties
    private var _isMeasuring: Bool = false {
        didSet {
            isMeasuringSource(_isMeasuring)
        }
    }
    
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
        
        didReceiveIsMeasuring = { [weak self] isMeasuring in
            self?._isMeasuring = isMeasuring
        }
    }
}
