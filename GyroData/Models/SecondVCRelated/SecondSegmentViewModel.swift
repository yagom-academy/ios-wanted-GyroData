//
//  SecondSegmentViewModel.swift
//  GyroData
//
//  Created by pablo.jee on 2022/09/20.
//

import Foundation

class SecondSegmentViewModel {
    // MARK: Input
    var didSegmentChange: (MotionType) -> () = { type in }
    var didReceiveIsMeasuring: (Bool) -> () = { isMeasuring in }
    
    // MARK: Output
    var selectedTypeSource: (MotionType) -> () = { type in } {
        didSet {
            selectedTypeSource(_selectedType)
        }
    }
    
    var isUserInteractionEnabledSource: (Bool) -> () = { type in } {
        didSet {
            isUserInteractionEnabledSource(!_isMeasuring)
        }
    }
    
    var selectedType: MotionType {
        return _selectedType
    }
    
    // MARK: Properties
    private var _selectedType: MotionType
    private var _isMeasuring: Bool = false {
        didSet {
            isUserInteractionEnabledSource(!_isMeasuring)
        }
    }
    
    
    //properties
    
    init() {
        _selectedType = .acc
        bind()
    }
    
    private func bind() {
        didSegmentChange = { [weak self] type in
            guard let self = self else { return }
            guard !self._isMeasuring else { return }
            self._selectedType = type
        }
        
        didReceiveIsMeasuring = { [weak self] isMeasuring in
            guard let self else { return }
            self._isMeasuring = isMeasuring
        }
    }
}
