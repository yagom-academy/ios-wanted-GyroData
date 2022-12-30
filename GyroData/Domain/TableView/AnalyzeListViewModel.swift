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
    func deleteButtonDidTap(indexPath: IndexPath)
    func cellDidTap(indexPath: IndexPath)
}

protocol AnalyzeListViewModelOutputInterface {
    var analysisPublisher: PassthroughSubject<[GyroData], Never> { get }
}

protocol AnalyzeListViewModelInterface {
    var input: AnalyzeListViewModelInputInterface { get }
    var output: AnalyzeListViewModelOutputInterface { get }
}

final class AnalyzeListViewModel: AnalyzeListViewModelInterface, AnalyzeListViewModelOutputInterface {
    var analysisPublisher = PassthroughSubject<[GyroData], Never>()
    var selectedItemPublisher = PassthroughSubject<[GraphModel], Never>()
    var playModePublisher = PassthroughSubject<[GraphModel], Never>()
    
    // MARK: AnalyzeViewModelInterface
    var input: AnalyzeListViewModelInputInterface { self }
    var output: AnalyzeListViewModelOutputInterface { self }

    // MARK: AnalyzeViewModelOutputInterface
    var analysis: [GyroData] = []
    var graph: [GraphModel] = []
    
    private func fetchCoreData() {
        guard let fetchedData = CoreDataManager.shared.read() else {
            return
        }
        
        analysis = fetchedData
    }
}

extension AnalyzeListViewModel: AnalyzeListViewModelInputInterface {
    func onViewDidLoad() {
        fetchCoreData()
    }
    
    func onViewWillAppear() {
        fetchCoreData()
    }

    func playButtonDidTap(indexPath: IndexPath) {
        guard let id = analysis[indexPath.row].id,
              let fetchedData = GraphFileManager.shared.loadJsonFile(fileName: id) else {
            return
        }
        
        graph = fetchedData
        playModePublisher.send(graph)
    }
    
    func deleteButtonDidTap(indexPath: IndexPath) {
        guard let id = analysis[indexPath.row].id else {
            return
        }
        
        GraphFileManager.shared.deleteJsonFile(fileName: id)
        CoreDataManager.shared.delete(data: analysis[indexPath.row])
        
        fetchCoreData()
    }
    
    func cellDidTap(indexPath: IndexPath) {
        guard let id = analysis[indexPath.row].id,
              let fetchedData = GraphFileManager.shared.loadJsonFile(fileName: id) else {
            return
        }
        graph = fetchedData
        selectedItemPublisher.send(graph)
    }
}
