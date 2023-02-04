//
//  MeasureViewModel.swift
//  GyroData
//
//  Created by leewonseok on 2023/02/03.
//

import Foundation

final class MeasureViewModel {
    private let motionManager = MotionManager()
    
    private var motionType: MotionType = .acc {
        didSet {
            typeHandler?(motionTypeIndex)
        }
    }
    private var coordinates: [Coordinate] = [] {
        didSet {
            guard let coordinate = coordinates.last else { return }
            graphHandler?(coordinate)
        }
    }
    
    private var measureState: Bool = true {
        didSet {
            measureHandler?(measureState)
        }
    }
    
    private var loading: Bool = false {
        didSet {
            loading ? loadingStartHandler?() :loadingStopHandler?()
        }
    }
    
    var motionTypeIndex: Int = 0 {
        didSet {
            motionType = motionTypeIndex == 0 ? .acc : .gyro
        }
    }
    
    
    private var typeHandler: ((Int) -> Void)?
    private var loadingStartHandler: (() -> Void)?
    private var loadingStopHandler: (() -> Void)?
    private var measureHandler: ((Bool) -> Void)?
    private var saveHandler: (() -> Void)?
    private var failHandler: (() -> Void)?
    private var emptyHandler: (() -> Void)?
    private var graphHandler: ((Coordinate) -> Void)?
    
    func bindType(handler: @escaping (Int) -> Void) {
        typeHandler = handler
    }
    
    func bindStartLoading(handler: @escaping () -> Void) {
        loadingStartHandler = handler
    }
    
    func bindStopLoading(handler: @escaping () -> Void) {
        loadingStopHandler = handler
    }
    
    func bindMeasureHandler(handler: @escaping (Bool) ->Void) {
        measureHandler = handler
    }
    
    func bindSaveHandler(handler: @escaping () -> Void) {
        saveHandler = handler
    }
    
    func bindFailHandler(handler: @escaping () -> Void) {
        failHandler = handler
    }
    
    func bindEmptyHandler(handler: @escaping () -> Void) {
        emptyHandler = handler
    }
    
    func bindDrawGraphView(handler: @escaping (Coordinate)-> Void) {
        graphHandler = handler
    }
    
    func load() {
        typeHandler?(motionTypeIndex)
        measureHandler?(measureState)
    }
    
    func save() {
        loading = true
        
        if coordinates.isEmpty {
            loading = false
            emptyHandler?()
            return
        }

        FileManager.default.save(path: UUID().uuidString, data: coordinates) { result in
            self.loading = false
            switch result {
            case .success(let path):
                CoreDataManager.shared.create(entity: MotionEntity.self) { entity in
                    entity.id = UUID(uuidString: path)
                    entity.date = Date()
                    entity.time = self.motionManager.second.decimalPlace(1)
                    entity.measureType = (self.motionType.rawValue)
                }
                self.saveHandler?()
            case .failure(_):
                self.failHandler?()
            }
        }
    }
    
    func measure() {
        measureState = false
        
        motionManager.configureTimeInterval(interval: 0.1)
        motionManager.start(type: motionType) { data in
            DispatchQueue.main.async {
                self.coordinates.append(data)
            }
        }
    }
    
    func stop() {
        measureState = true
        motionManager.stop()
    }
}
