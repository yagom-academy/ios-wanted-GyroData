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
    
    mutating private func setInitialMotions() {
        guard let initialMotions = readService.read(from: 0) else { return }
        
        motions = initialMotions
    }
    
    mutating private func setNextPageMotions() {
        guard motions.count % 10 == 0 else { return }
        
        let currentPage: Int = Int(motions.count / 10)
        guard let nextPageMotions = readService.read(from: currentPage * 10), !nextPageMotions.isEmpty else { return }
        
        motions += nextPageMotions
    }
    
    private func tapMotionAction(indexPath: IndexPath) {
        let selectedMotion = motions[indexPath.row]
        
        delegate?.motionsListViewModel(selectedGraphMotion: selectedMotion)
    }
    
    mutating private func tapMotionDeleteAction(indexPath: IndexPath) {
        let selectedMotion = motions[indexPath.row]
        
        if deleteService.delete(selectedMotion.id) {
            motions.remove(at: indexPath.row)
        }
    }
    
    private func tapMotionPlayAction(indexPath: IndexPath) {
        let selectedMotion = motions[indexPath.row]
        
        delegate?.motionsListViewModel(selectedPlayMotion: selectedMotion)
    }
}
