//
//  MotionsListViewModel.swift
//  GyroData
//
//  Created by Ayaan, Wonbi on 2023/01/31.
//

import Foundation

protocol MotionsListViewModelDelegate: AnyObject {
    func motionsListViewModel(didChange motions: [Motion])
    func motionsListViewModel(selectedGraphMotionID id: String)
    func motionsListViewModel(selectedPlayMotionID id: String)
}

final class MotionsListViewModel {
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
    
    init(readService: CoreDataMotionReadable, deleteService: MotionDeletable, delegate: MotionsListViewModelDelegate? = nil) {
        self.readService = readService
        self.deleteService = deleteService
        self.delegate = delegate
    }
    
    func action(_ action: Action) {
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
    
    func setDelegate(_ delegate: MotionsListViewModelDelegate) {
        self.delegate = delegate
    }
}

private extension MotionsListViewModel {
    func setInitialMotions() {
        guard let initialMotions = readService.read(from: 0) else { return }
        
        motions = initialMotions
    }
    
    func setNextPageMotions() {
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
        
        delegate?.motionsListViewModel(selectedGraphMotionID: selectedMotion.id)
    }
    
    func tapMotionDeleteAction(indexPath: IndexPath) {
        let selectedMotion = motions[indexPath.row]
        
        if deleteService.delete(selectedMotion.id) {
            motions.remove(at: indexPath.row)
        }
    }
    
    func tapMotionPlayAction(indexPath: IndexPath) {
        let selectedMotion = motions[indexPath.row]
        
        delegate?.motionsListViewModel(selectedPlayMotionID: selectedMotion.id)
    }
}
