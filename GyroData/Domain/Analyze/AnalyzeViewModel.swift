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
    func onViewDidLoad()
    func tapAnalyzeButton()
    func tapStopButton()
    func tapSaveButton()
    func changeAnalyzeMode(_ segmentcontrolNumber: Int)
}

protocol AnalyzeViewModelOutputInterface {
    var analysisPublisher: PassthroughSubject<[GraphModel], Never> { get }
    var isLoadingPublisher: PassthroughSubject<Bool, Never> { get }
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
    var dissmissPublisher = PassthroughSubject<Void, Never>()
    
    @Published var analysis: [GraphModel] = []
    @Published var testArr : [GraphModel] = []
    
    private let analysisManager: AnalysisManager
    private var timer: Timer?
    private var analyzeMode: Int = 0
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
            let data = self.analysisManager.startAnalyse()
            self.analysis.append(.init(x: data.x, y: data.y, z: data.z, measurementTime: measureTime))
            print(self.analysis)
        })
        
        if let timer = self.timer {
            RunLoop.current.add(timer, forMode: .default)
        }
    }
    
    private func stopTimer() {
        if timer != nil {
            timer?.invalidate()
            timer = nil
            analysisManager.stopAnalyse()
        }
    }
}

extension AnalyzeViewModel: AnalyzeViewModelInputInterface {
    func onViewWillAppear() {
    }
    
    func onViewDidLoad() {
    }
    
    func tapAnalyzeButton() {
        analyzeData()
        bind()
    }
    
    func tapStopButton() {
        stopTimer()
        analysisManager.stopAnalyse()
        print(analysis)
    }
    
    func tapSaveButton() {
        isLoadingPublisher.send(true)
        // TODO: save CoreData
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            guard let self = self else { return }
            if self.analyzeMode == 0 {
                self.cellModel = [.init(
                    id: UUID(),
                    analysisType: AnalysisType.accelerate.rawValue,
                    savedAt: Date.now,
                    measurementTime: self.analysis.last?.measurementTime ?? 0.0
                )]
                print(self.cellModel)
            } else if self.analyzeMode == 1 {
                self.cellModel = [.init(
                    id: UUID(),
                    analysisType: AnalysisType.gyroscope.rawValue,
                    savedAt: Date.now,
                    measurementTime: self.analysis.last?.measurementTime ?? 0.0
                )]
                print(self.cellModel)
            }
            self.isLoadingPublisher.send(false)
            self.dissmissPublisher.send(())
        }
    }
    
    func changeAnalyzeMode(_ segmentIndex: Int) {
        analyzeMode = segmentIndex
    }
}

extension AnalyzeViewModel: ObservableObject {
    func bind() {
        store = $analysis
            .sink { [weak self] model in
                guard let self = self else { return }
                self.testArr = model
            }
    }
}
