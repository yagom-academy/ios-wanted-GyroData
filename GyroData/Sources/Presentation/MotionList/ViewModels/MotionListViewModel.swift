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
    
    // MARK: - Output
    let motions: Observable<[MotionEntity]> = .init([])
    
    // MARK: - Input
    func didDeleteAction(at index: Int) {
        print(#function)
    }
}
