//
//  MotionLogListViewModel.swift
//  GyroData
//
//  Copyright (c) 2023 Jeremy All rights reserved.
    

import Foundation

final class MotionLogListViewModel {
    
    private var updateTrigger: (([MotionLogCellViewModel]) -> Void)?
    
    // TODO: Create actual usecase
    var cellItems: [MotionLogCellViewModel] = [] {
        didSet {
            updateTrigger?(cellItems)
        }
    }
    
    func bind(_ completion: @escaping ([MotionLogCellViewModel]) -> Void) {
        // TODO: Add bindings
        updateTrigger = completion
        completion(cellItems)
    }
}
