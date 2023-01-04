//
//  MotionListViewModel.swift
//  GyroData
//
//  Created by Ari on 2022/12/27.
//

import Foundation

protocol MotionListViewModelInput {
    
    func didDeleteAction(at index: Int)
    func prefetch()
    func updateMotions()
    
}

protocol MotionListViewModelOutput {
    
    var motions: Observable<[MotionEntity]> { get }
    var isLoading: Observable<Bool> { get }
    
}

protocol MotionListViewModel: MotionListViewModelInput, MotionListViewModelOutput {}

final class DefaultMotionListViewModel: MotionListViewModel {
    
    private let storage: MotionStorage
    private var currentPage: UInt = 1
    
    init(storage: MotionStorage = CoreDataMotionStorage()) {
        self.storage = storage
        motions.value = storage.fetch(page: 1)
    }
    
    // MARK: - Output
    let motions: Observable<[MotionEntity]> = .init([])
    let isLoading: Observable<Bool> = .init(false)
    
    // MARK: - Input
    func didDeleteAction(at index: Int) {
        guard motions.value[safe: index] != nil else {
            return
        }
        let motion = motions.value.remove(at: index)
        storage.delete(motion)
    }
    
    func prefetch() {
        guard isLoading.value == false else {
            return
        }
        isLoading.value = true
        let newMotions = storage.fetch(page: currentPage + 1)
        if newMotions.isEmpty == false {
            currentPage += 1
            motions.value.append(contentsOf: newMotions)
        }
        isLoading.value = false
    }
    
    func updateMotions() {
        motions.value = storage.fetch(page: 1)
        currentPage = 1
    }
}
