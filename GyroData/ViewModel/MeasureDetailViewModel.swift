//
//  MeasureDetailViewModel.swift
//  GyroData
//
//  Created by leewonseok on 2023/02/03.
//

import Foundation

final class MeasureDetailViewModel {
    var motionData: MotionEntity
    private var coordinates: [Coordinate] = []
    var pageType: MeasureViewType
    private var timer: Timer?
    
    var loading: Bool = false {
        didSet {
            loading ? loadingStartHandler?() : loadingStopHandler?()
        }
    }
    
    var second: Double? {
        didSet {
            secondHandler?(second)
        }
    }
    
    init(motionData: MotionEntity, pageType: MeasureViewType) {
        self.motionData = motionData
        self.pageType = pageType
    }
    
    private var graphHandler: ((Coordinate) -> Void)?
    private var loadingStartHandler: (() -> Void)?
    private var loadingStopHandler: (() -> Void)?
    private var secondHandler: ((Double?)->Void)?
    private var playHandler: ((Bool)->Void)?
    private var stopHandler: ((Bool)->Void)?
    
    func bindStartLoading(handler: @escaping () -> Void) {
        loadingStartHandler = handler
    }
    
    func bindStopLoading(handler: @escaping () -> Void) {
        loadingStopHandler = handler
    }
    
    func bindSecond(handler: @escaping (Double?)->Void){
        secondHandler = handler
    }
    
    func bindDrawGraphView(handler: @escaping (Coordinate)-> Void) {
        graphHandler = handler
    }
    
    func bindPlayButton(handler: @escaping (Bool)->Void) {
        playHandler = handler
    }
    
    func bindStopButton(handler: @escaping (Bool)->Void) {
        stopHandler = handler
    }
    
    
    func fetchData() {
        guard let fileId = motionData.id,
              let fileData = FileManager.default.load(path: fileId.uuidString) else { return }
        
        coordinates = fileData
    }
    
    func graphViewLoad() {
        loading = false
        if pageType == .view {
            drawAll()
        }
    }
    
    func load() {
        if pageType == .view {
            playHandler?(true)
        } else {
            second = 0
        }
        stopHandler?(true)
    }
    
    func drawAll() {
        coordinates.forEach { coordinate in
            graphHandler?(coordinate)
        }
    }
    
    func start() {
        var currentIndex: Int = 0
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { _ in
            if currentIndex >= self.coordinates.count {
                self.stop()
                return
            }
            self.graphHandler?(self.coordinates[currentIndex])
            
            currentIndex += 1
            self.second = Double(currentIndex) / 10
        })
        stopHandler?(false)
        playHandler?(true)
    }
    
    func stop() {
        timer?.invalidate()
        stopHandler?(true)
        playHandler?(false)
    }
}
