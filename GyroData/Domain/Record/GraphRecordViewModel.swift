//
//  GraphRecordViewModel.swift
//  GyroData
//
//  Created by unchain, Ellen J, yeton on 2022/12/30.
//

import Foundation
import Combine

protocol GraphRecordViewModelInputInterface {
    func onViewDidLoad()
    func onViewWillAppear()
}

protocol GraphRecordViewModelOutputInterface {
    var analysisPublisher: PassthroughSubject<[GraphModel], Never> { get }
}

protocol GraphRecordViewModelInterface {
    var input: GraphRecordViewModelInputInterface { get }
    var output: GraphRecordViewModelOutputInterface { get }
}

class GraphRecordViewModel: GraphRecordViewModelInterface, GraphRecordViewModelOutputInterface {
    var analysisPublisher = PassthroughSubject<[GraphModel], Never>()
    
    var input: GraphRecordViewModelInputInterface { self }
    var output: GraphRecordViewModelOutputInterface { self }
    
    var store: AnyCancellable?
    @Published var model: [GraphModel] = []
    @Published var environmentGraphModel: EnvironmentGraphModel = .init()
    
    init(model: [GraphModel]) {
        self.model = model
    }
}

extension GraphRecordViewModel: GraphRecordViewModelInputInterface {
    func onViewDidLoad() {
        bind()
    }
    
    func onViewWillAppear() {
        
    }
}

extension GraphRecordViewModel: ObservableObject {
    func bind() {
        store = $model
            .sink { [weak self] graphData in
                guard let self = self else {
                    return
                }
                
                self.environmentGraphModel.graphModels = graphData
            }
    }
}
