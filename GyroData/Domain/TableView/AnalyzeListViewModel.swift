//
//  AnalyzeListViewModel.swift
//  GyroData
//
//  Created by unchain on 2022/12/30.
//

import Foundation
import CoreData
import Combine

protocol AnalyzeListViewModelInputInterface {
    func onViewDidLoad()
    func onViewWillAppear()
    func playButtonDidTap(indexPath: IndexPath)
    func deleteButtonDidTap()
    func cellDidTap()
    func measurementButtonDidTap()
}

protocol AnalyzeListViewModelOutputInterface {
    var analysisPublisher: PassthroughSubject<[GyroData], Never> { get }
}

protocol AnalyzeListViewModelInterface {
    var input: AnalyzeListViewModelInputInterface { get }
    var output: AnalyzeListViewModelOutputInterface { get }
}

final class AnalyzeListViewModel: AnalyzeListViewModelInterface {
    var analysisPublisher = PassthroughSubject<[GyroData], Never>()

    // MARK: AnalyzeViewModelInterface
    var input: AnalyzeListViewModelInputInterface { self }
    var output: AnalyzeListViewModelOutputInterface { self }

    // MARK: AnalyzeViewModelOutputInterface
    var analysis: [GyroData] = []
    var graph: [GraphModel] = []
}

extension AnalyzeListViewModel: AnalyzeListViewModelInputInterface {
    func onViewDidLoad() {
        guard let fetchedData = CoreDataManager.shared.read() else {
            return
        }
        
        analysis = fetchedData
    }
    
    func onViewWillAppear() {
        guard let fetchedData = CoreDataManager.shared.read() else {
            return
        }
        
        analysis = fetchedData
    }

    func playButtonDidTap(indexPath: IndexPath) {
        guard let id = analysis[indexPath.row].id,
              let fetchedData = GraphFileManager.shared.loadJsonFile(fileName: id) else {
            return
        }
        
        graph = fetchedData
    }
    
    func deleteButtonDidTap() {
        
    }
    
    func cellDidTap() {
        
    }
    
    func measurementButtonDidTap() {
        
    }
}

extension AnalyzeListViewModel: AnalyzeListViewModelOutputInterface {
    func data전달() {
        
    }
}
