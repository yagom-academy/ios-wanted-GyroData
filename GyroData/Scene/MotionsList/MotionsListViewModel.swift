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
    
    private var motions: [Motion] = [] {
        didSet {
            delegate?.motionsListViewModel(didChange: motions)
        }
    }
    
    private let readService: CoreDataMotionReadable
    private let deleteService: MotionDeletable
    private weak var delegate: MotionsListViewModelDelegate?
    
    mutating func action(_ action: Action) {
        switch action {
        case .viewWillApear:
            setInitialMotions()
        case .nextPageRequest:
            setNextPageMotions()
        case .motionTap(let indexPath):
            tapMotionAction(indexPath: indexPath)
        case .motionDelete(let indexPath):
            tapMotionDeleteAction(indexPath: indexPath)
        case .motionPlay(let indexPath):
            tapMotionPlayAction(indexPath: indexPath)
        }
    }
}

private extension MotionsListViewModel {
    mutating func setInitialMotions() {
        guard let initialMotions = readService.read(from: 0) else { return }
        
        motions = initialMotions
    }
    
    mutating func setNextPageMotions() {
        guard let count = readService.count(),
              count > motions.count,
              let nextPageMotions = readService.read(from: motions.count)
        else {
            return
        }
        
        motions += nextPageMotions
    }
    
    func tapMotionAction(indexPath: IndexPath) {
        let selectedMotion = motions[indexPath.row]
        
        delegate?.motionsListViewModel(selectedGraphMotion: selectedMotion)
    }
    
    mutating func tapMotionDeleteAction(indexPath: IndexPath) {
        let selectedMotion = motions[indexPath.row]
        
        if deleteService.delete(selectedMotion.id) {
            motions.remove(at: indexPath.row)
        }
    }
    
    func tapMotionPlayAction(indexPath: IndexPath) {
        let selectedMotion = motions[indexPath.row]
        
        delegate?.motionsListViewModel(selectedPlayMotion: selectedMotion)
    }
}
