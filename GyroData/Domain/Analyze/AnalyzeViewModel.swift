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
    
    @Published var analysis: [GraphModel] = [
        .init(x: 1, y: 2, z: 3, measurementTime: 1),
        .init(x: 1, y: 2, z: 3, measurementTime: 2),
        .init(x: 1, y: 2, z: 3, measurementTime: 3),
        .init(x: 1, y: 2, z: 3, measurementTime: 4),
        .init(x: 1, y: 2, z: 3, measurementTime: 5),
        .init(x: 1, y: 2, z: 3, measurementTime: 6),
        .init(x: 1, y: 2, z: 3, measurementTime: 7),
    ]
    
    @Published var testArr : [GraphModel] = []
    
    private let analysisManager: AnalysisManager
    private var timer: Timer?
    private var analyzeMode: Int = 0
    private var cellModel: [CellModel] = []
    
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
            self.analysis.append(.init(x: data.x, y: data.y, z: data.z, measurementTime: timer.timeInterval))
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
        // TODO: save CoreData
        if analyzeMode == 0 {
            cellModel.append(.init(
                id: UUID(),
                analysisType: AnalysisType.accelerate.rawValue,
                savedAt: Date.now,
                measurementTime: analysis.last?.measurementTime ?? 0.0
            ))
            print(cellModel)
        } else if analyzeMode == 1 {
            cellModel.append(.init(
                id: UUID(),
                analysisType: AnalysisType.gyroscope.rawValue,
                savedAt: Date.now,
                measurementTime: analysis.last?.measurementTime ?? 0.0
            ))
            print(cellModel)
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
