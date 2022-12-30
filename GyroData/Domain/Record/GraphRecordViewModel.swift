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
    func tappedPlayButton()
    func tappedStopButton()
}

protocol GraphRecordViewModelOutputInterface {
    var secondPublisher: PassthroughSubject<String, Never> { get }
    var playCompletePublisher: PassthroughSubject<Void, Never> { get }
}

protocol GraphRecordViewModelInterface {
    var input: GraphRecordViewModelInputInterface { get }
    var output: GraphRecordViewModelOutputInterface { get }
}

class GraphRecordViewModel: GraphRecordViewModelInterface, GraphRecordViewModelOutputInterface {
    var input: GraphRecordViewModelInputInterface { self }
    var output: GraphRecordViewModelOutputInterface { self }
    var store: AnyCancellable?
    var secondPublisher = PassthroughSubject<String, Never>()
    var playCompletePublisher = PassthroughSubject<Void, Never>()
    private var timer: Timer?
    private var currentSecond: String = ""
    @Published var model: [GraphModel] = []
    @Published var environmentGraphModel: EnvironmentGraphModel = .init()
    
    init(model: [GraphModel]) {
        self.model = model
    }
    
    func playGraph() {
        var storedModel = model
        model = []
        timer = Timer(fire: Date(), interval: 0.1, repeats: true, block: { [weak self] (timer) in
            guard let self = self else { return }
            if storedModel.isEmpty {
                self.playCompletePublisher.send(())
                self.stopTimer()
            } else {
                let data = storedModel.removeFirst()
                self.secondPublisher.send(String(format: "%.1f", data.measurementTime))
                self.model.append(data)
            }
        })
        
        if let timer = self.timer {
            RunLoop.current.add(timer, forMode: .default)
        }
    }
    
    private func stopTimer() {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
    }
}

extension GraphRecordViewModel: GraphRecordViewModelInputInterface {
    func onViewDidLoad() {
        bind()
    }
    
    func tappedPlayButton() {
        playGraph()
    }
    
    func tappedStopButton() {
        stopTimer()
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
