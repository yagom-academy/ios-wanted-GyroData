//
//  DetailViewModel.swift
//  GyroData
//
//  Created by Aejong on 2023/02/03.
//

import Foundation

final class DetailViewModel {
    typealias StringHandler = (String) -> Void
    typealias MotionMeasuresHandler = (MotionMeasures, Double) -> Void
    
    private let model: MotionData
    private let currentType: PageType
    private let fileManager: FileManagerProtocol
    
    private var motionMeasures: MotionMeasures = MotionMeasures(axisX: [], axisY: [], axisZ: []) {
        didSet {
            measuresHandler?(motionMeasures, model.duration)
        }
    }
    
    private var date: String = String() {
        didSet {
            dateHandler?(date)
        }
    }
    
    private var pageType: String = String() {
        didSet {
            pageTypeHandler?(pageType)
        }
    }
    
    private var dateHandler: StringHandler?
    private var pageTypeHandler: StringHandler?
    private var measuresHandler: MotionMeasuresHandler?
    
    init(_ motionData: MotionData, by type: PageType, fileManager: FileManagerProtocol) {
        model = motionData
        currentType = type
        self.fileManager = fileManager
    }
    
    func fetchData() {
        date = DateFormatter.measuredDateFormatter.string(from: model.measuredDate)
        pageType = currentType.description
        fetchMeasures()
    }
    
    private func fetchMeasures() {
        fileManager.load(fileName: model.id) { result in
            switch result {
            case .success(let data):
                self.motionMeasures = data
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    func bindDate(_ handler: @escaping StringHandler) {
        dateHandler = handler
    }
    
    func bindPageType(_ handler: @escaping StringHandler) {
        pageTypeHandler = handler
    }
    
    func bindGraphData(_ handler: @escaping MotionMeasuresHandler) {
        measuresHandler = handler
    }
}

