//
//  AnalyzeViewModel.swift
//  GyroData
//
//  Created by Ellen J on 2022/12/28.
//

import Foundation
import Combine

protocol AnalyzeViewModelInputInterface {
    func onViewWillAppear()
    func tapAnalyzeButton()
    func tapStopButton()
    func tapSaveButton()
    func changeAnalyzeMode(_ segmentControlNumber: Int)
}

protocol AnalyzeViewModelOutputInterface {
    var analysisPublisher: PassthroughSubject<[GraphModel], Never> { get }
    var isLoadingPublisher: PassthroughSubject<Bool, Never> { get }
    var dismissPublisher: PassthroughSubject<Void, Never> { get }
}

protocol AnalyzeViewModelInterface {
    var input: AnalyzeViewModelInputInterface { get }
    var output: AnalyzeViewModelOutputInterface { get }
}

final class AnalyzeViewModel: AnalyzeViewModelInterface, AnalyzeViewModelOutputInterface {
    var store: AnyCancellable?

    // MARK: AnalyzeViewModelInterface
    var input: AnalyzeViewModelInputInterface { self }
    var output: AnalyzeViewModelOutputInterface { self }
    
    // MARK: AnalyzeViewModelOutputInterface
    var analysisPublisher = PassthroughSubject<[GraphModel], Never>()
    var isLoadingPublisher = PassthroughSubject<Bool, Never>()
    var dismissPublisher = PassthroughSubject<Void, Never>()
    
    @Published var environment: EnvironmentGraphModel = .init()
    @Published var analysis: [GraphModel] = []
    
    private let analysisManager: AnalysisManager
    private var timer: Timer?
    private var analyzeMode: AnalysisType = .accelerate
    private var cellModel: [CellModel] = []
    private var isLoading = false
    
    init(
        analysisManager: AnalysisManager
    ) {
        self.analysisManager = analysisManager
    }
    
    private func analyzeData() {
        let now = Date.now.timeIntervalSince1970
        analysis = []
        timer = Timer(fire: Date(), interval: 0.1, repeats: true, block: { [weak self] (timer) in
            guard let self = self else { return }
            let date = timer.fireDate.timeIntervalSince1970
            let measureTime = date - now
            let data = self.analysisManager.startAnalyze(mode: self.analyzeMode)
            self.analysis.append(.init(x: data.x, y: data.y, z: data.z, measurementTime: measureTime))
        })
        
        if let timer = self.timer {
            RunLoop.current.add(timer, forMode: .default)
        }
    }
    
    private func stopTimer() {
        if timer != nil {
            timer?.invalidate()
            timer = nil
            analysisManager.stopAnalyze(mode: self.analyzeMode)
        }
    }
}

extension AnalyzeViewModel: AnalyzeViewModelInputInterface {
    func onViewWillAppear() {
        bind()
    }
    
    func tapAnalyzeButton() {
        analyzeData()
    }
    
    func tapStopButton() {
        stopTimer()
        analysisManager.stopAnalyze(mode: self.analyzeMode)
    }
    
    func tapSaveButton() {
        isLoadingPublisher.send(true)
        DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
            guard let self = self else { return }
            switch self.analyzeMode {
            case .accelerate:
                self.cellModel = [CellModel.init(
                    id: UUID(),
                    analysisType: AnalysisType.accelerate.rawValue,
                    savedAt: Date.now,
                    measurementTime: self.analysis.last?.measurementTime ?? 0.0
                )]
                CoreDataManager.shared.create(model: self.cellModel, fileModel: self.analysis)
            case .gyroscope:
                self.cellModel = [.init(
                    id: UUID(),
                    analysisType: AnalysisType.gyroscope.rawValue,
                    savedAt: Date.now,
                    measurementTime: self.analysis.last?.measurementTime ?? 0.0
                )]
                CoreDataManager.shared.create(model: self.cellModel, fileModel: self.analysis)
            }
            
            self.isLoadingPublisher.send(false)
            self.dismissPublisher.send(())
        }
    }
    
    func changeAnalyzeMode(_ segmentIndex: Int) {
        if segmentIndex == 0 {
            self.analyzeMode = .accelerate
        } else if segmentIndex == 1 {
            self.analyzeMode = .gyroscope
        }
    }
}

extension AnalyzeViewModel: ObservableObject {
    func bind() {
        store = $analysis
            .sink { [weak self] model in
                guard let self = self else { return }
                self.environment.graphModels = model
            }
    }
}
