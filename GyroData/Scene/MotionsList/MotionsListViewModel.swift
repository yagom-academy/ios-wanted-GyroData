//
//  MotionsListViewModel.swift
//  GyroData
//
//  Created by Ayaan, Wonbi on 2023/01/31.
//

import Foundation

protocol MotionsListViewModelDelegate: AnyObject {
    func motionsListViewModel(didChange motions: [Motion])
    func motionsListViewModel(selectedGraphMotion motion: Motion)
    func motionsListViewModel(selectedPlayMotion motion: Motion)
}

struct MotionsListViewModel {
    enum Action {
        case viewWillApear
        case nextPageRequest
        case motionTap(indexPath: IndexPath)
        case motionDelete(indexPath: IndexPath)
        case motionPlay(indexPath: IndexPath)
    }
    
    var motions: [Motion] = [] {
        didSet {
            delegate?.motionsListViewModel(didChange: motions)
        }
    }
    
    let readService: CoreDataMotionReadable
    let deleteService: MotionDeletable
    weak var delegate: MotionsListViewModelDelegate?
    
    mutating func action(_ action: Action) {
    }
}
