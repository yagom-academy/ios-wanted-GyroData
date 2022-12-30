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
    func onViewWillAppear()
    func onViewDidLoad()
}

protocol AnalyzeListViewModelOutputInterface {
    var analysisPublisher: PassthroughSubject<[CellModel], Never> { get }
}

protocol AnalyzeListViewModelInterface {
    var input: AnalyzeListViewModelInputInterface { get }
    var output: AnalyzeListViewModelOutputInterface { get }
}

final class AnalyzeListViewModel: AnalyzeListViewModelInterface, AnalyzeListViewModelOutputInterface {
    var analysisPublisher = PassthroughSubject<[CellModel], Never>()

    // MARK: AnalyzeViewModelInterface
    var input: AnalyzeListViewModelInputInterface { self }
    var output: AnalyzeListViewModelOutputInterface { self }

    // MARK: AnalyzeViewModelOutputInterface
    var analysis: [CellModel] = []
}

extension AnalyzeListViewModel: AnalyzeListViewModelInputInterface {
    func onViewWillAppear() {
        bind()
    }

    func onViewDidLoad() {
    }
}

extension AnalyzeListViewModel: ObservableObject {
    func bind() {
      
    }
}
