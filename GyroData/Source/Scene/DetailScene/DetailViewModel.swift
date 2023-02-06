//
//  DetailViewModel.swift
//  GyroData
//
//  Created by Aejong on 2023/02/03.
//

import Foundation

final class DetailViewModel {
    typealias StringHandler = (String) -> Void
    typealias PageTypeHandler = (String, Bool, MotionMeasures) -> Void
    typealias DurationHandler = (Double) -> Void
    
    private var date: String = String() {
        didSet {
            dateHandler?(date)
        }
    }
    private var pageType: PageType = .view {
        didSet {
            let isViewPage = pageType == .view
            pageTypeHandler?(pageType.description, isViewPage, motionMeasures)
        }
    }
    private var motionMeasures: MotionMeasures = MotionMeasures(axisX: [], axisY: [], axisZ: [])
    private var motionCoordinate: MotionCoordinate? {
        didSet {
            guard let motionCoordinate = motionCoordinate else { return }
            measuresHandler?(motionCoordinate)
        }
    }
    private var isPlaying: Bool = false {
        didSet {
            let imageName = isPlaying ? "stop.fill" : "play.fill"
            timerHandler?(imageName)
        }
    }
    private var timerSecond: Double = Double() {
        didSet {
            durationHandler?(timerSecond)
        }
    }
    
    private var dateHandler: StringHandler?
    private var pageTypeHandler: PageTypeHandler?
    private var measuresHandler: ((MotionCoordinate) -> Void)?
    private var timerHandler: StringHandler?
    private var durationHandler: DurationHandler?
    
    private let model: MotionData
    private let currentType: PageType
    private let fileManager: FileManagerProtocol
    private let timer: MeasureTimer
    
    init(_ motionData: MotionData, by type: PageType, fileManager: FileManagerProtocol) {
        model = motionData
        currentType = type
        self.fileManager = fileManager
        timer = MeasureTimer(deadline: model.duration, interval: 0.1)
    }
    
    func fetchData() {
        date = DateFormatter.measuredDateFormatter.string(from: model.measuredDate)
        fetchMeasures()
        pageType = currentType
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
    
    func bindPageType(_ handler: @escaping PageTypeHandler) {
        pageTypeHandler = handler
    }
    
    func bindGraphCoordinate(_ handler: @escaping (MotionCoordinate) -> Void) {
        measuresHandler = handler
    }
    
    func bindTimer(_ handler: @escaping StringHandler) {
        timerHandler = handler
    }
    
    func bindDuration(_ handler: @escaping DurationHandler) {
        durationHandler = handler
    }
}

extension DetailViewModel {
    func touchButton() {
        switch isPlaying {
        case true:
            timer.stop() 
            timerSecond = 0
            isPlaying = false
            fetchData()
        case false:
            timer.activate { [weak self] in
                self?.timerSecond += 0.1
                self?.createMotionCoordinate()
            }
            isPlaying = true
        }
    }
    
    private func createMotionCoordinate() {
        let x = motionMeasures.axisX.removeFirst()
        let y = motionMeasures.axisY.removeFirst()
        let z = motionMeasures.axisZ.removeFirst()
        
        motionCoordinate = MotionCoordinate(x: x, y: y, z: z)
    }
}

