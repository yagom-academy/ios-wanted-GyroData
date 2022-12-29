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
}

protocol AnalyzeViewModelOutputInterface {
    var analysisPublisher: PassthroughSubject<[TestAnalysis], Never> { get }
    var measuredAnalysisPublisher: PassthroughSubject<TestMeasuredAnalysis, Never> { get }
}

protocol AnalyzeViewModelInterface {
    var input: AnalyzeViewModelInputInterface { get }
    var output: AnalyzeViewModelOutputInterface { get }
}

final class AnalyzeViewModel: AnalyzeViewModelInterface, AnalyzeViewModelOutputInterface, ObservableObject {
    
    var store: AnyCancellable?
    
    // MARK: AnalyzeViewModelInterface
    var input: AnalyzeViewModelInputInterface { self }
    var output: AnalyzeViewModelOutputInterface { self }
    
    // MARK: AnalyzeViewModelOutputInterface
    var analysisPublisher = PassthroughSubject<[TestAnalysis], Never>()
    var measuredAnalysisPublisher = PassthroughSubject<TestMeasuredAnalysis, Never>()
    
    @Published var analysis: [Analysis] = [
        .init(analysisType: .accelerate, x: 11, y: 20, z: 30, measurementTime: 1, savedAt: Date()),
        .init(analysisType: .accelerate, x: 12, y: 20, z: 30, measurementTime: 2, savedAt: Date()),
        .init(analysisType: .accelerate, x: 13, y: 20, z: 30, measurementTime: 3, savedAt: Date()),
        .init(analysisType: .accelerate, x: 14, y: 20, z: 30, measurementTime: 4, savedAt: Date()),
    ]
    
    @Published var testAnalysis: [Analysis]  = [
        .init(analysisType: .accelerate, x: 11, y: 20, z: 30, measurementTime: 1, savedAt: Date()),
        .init(analysisType: .accelerate, x: 12, y: 20, z: 30, measurementTime: 2, savedAt: Date())
    ]
    
    private let analysisManager: AnalysisManager
    
    init(
        analysisManager: AnalysisManager
    ) {
        self.analysisManager = analysisManager
    }
    
    @Published var testArr : [Analysis] = []
    
    func bind() {
        store = $analysis
            .sink { [weak self] model in
                guard let self = self else { return }
                self.testArr = model
            }
    }
}

extension AnalyzeViewModel: AnalyzeViewModelInputInterface {
    func onViewWillAppear() {
    }
    
    func onViewDidLoad() {
    }
    
    func tapAnalyzeButton() {
        
        analysis.append(contentsOf: [
            .init(analysisType: .accelerate, x: 10, y: 20, z: 30, measurementTime: 1, savedAt: Date()),
            .init(analysisType: .accelerate, x: 10, y: 20, z: 30, measurementTime: 2, savedAt: Date()),
            .init(analysisType: .accelerate, x: 10, y: 20, z: 30, measurementTime: 3, savedAt: Date()),
            .init(analysisType: .accelerate, x: 10, y: 20, z: 30, measurementTime: 4, savedAt: Date()),
            .init(analysisType: .accelerate, x: 10, y: 20, z: 30, measurementTime: 5, savedAt: Date()),
            .init(analysisType: .accelerate, x: 10, y: 20, z: 30, measurementTime: 6, savedAt: Date()),
            .init(analysisType: .accelerate, x: 10, y: 20, z: 30, measurementTime: 7, savedAt: Date()),
            .init(analysisType: .accelerate, x: 10, y: 20, z: 30, measurementTime: 8, savedAt: Date()),
            .init(analysisType: .accelerate, x: 10, y: 20, z: 30, measurementTime: 9, savedAt: Date()),
            .init(analysisType: .accelerate, x: 10, y: 20, z: 30, measurementTime: 10, savedAt: Date()),
            .init(analysisType: .accelerate, x: 10, y: 20, z: 30, measurementTime: 11, savedAt: Date()),
            .init(analysisType: .accelerate, x: 10, y: 20, z: 30, measurementTime: 12, savedAt: Date())
        ])
        bind()
    }
    
    func tapStopButton() {
    }
}
