//
//  MotionListViewModel.swift
//  GyroData
//
//  Created by Ari on 2022/12/27.
//

import Foundation

protocol MotionListViewModelInput {
    
    func didDeleteAction(at index: Int)
    
}

protocol MotionListViewModelOutput {
    
    var motions: Observable<[MotionEntity]> { get }
    
}

protocol MotionListViewModel: MotionListViewModelInput, MotionListViewModelOutput {}

final class DefaultMotionListViewModel: MotionListViewModel {
    
    private let storage: MotionStorage
    
    init(storage: CoreDataMotionStorage = .init()) {
        self.storage = storage
        motions.value = storage.fetch(page: 1)
    }
    
    // MARK: - Output
    let motions: Observable<[MotionEntity]> = .init([])
    
    // MARK: - Input
    func didDeleteAction(at index: Int) {
        guard motions.value[safe: index] != nil else {
            return
        }
        motions.value.remove(at: index)
    }
}
