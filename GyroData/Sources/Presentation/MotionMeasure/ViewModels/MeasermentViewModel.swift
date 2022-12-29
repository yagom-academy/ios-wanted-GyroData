//
//  MeasermentViewModel.swift
//  GyroData
//
//  Created by 우롱차 on 2022/12/27.
//

import Foundation

protocol MeasermentViewModelInput {

    func measerStart(type: MotionType)
    func measerStop(type: MotionType)
    func measerSave(type: MotionType) throws
    func measerCancle(type: MotionType)
    
}

protocol MeasermentViewModelOutput {
    
    var status: Observable<MeasermentStatus> { get }
    var motions: Observable<[MotionValue]> { get }
    var currentMotion: Observable<MotionValue?> { get }
    
}

protocol MeasermentViewModel: MeasermentViewModelInput, MeasermentViewModelOutput {}

enum MeasermentStatus {
    case ready, start, stop
}

final class DefaultMeasermentViewModel: MeasermentViewModel {
    
    private enum Constant {
        static let maxCount = 600
    }
    
    private let storage: MotionStorage
    private let coreMotionManager: CoreMotionManager
    var motions: Observable<[MotionValue]> = .init([])
    var status: Observable<MeasermentStatus> = .init(.ready)
    var currentMotion: Observable<MotionValue?> = .init(nil)
    
    init(
        manger: CoreMotionManager = CoreMotionManager(),
        storage: MotionStorage = CoreDataMotionStorage()
    ) {
        self.coreMotionManager = manger
        self.storage = storage
    }
    
    func measerStart(type: MotionType) {
        status.value = .start
        switch type {
        case .gyro:
            coreMotionManager.bind(gyroHandler: { data, error in
                if let data = data {
                    let motionValue = MotionValue(data)
                    self.currentMotion.value = motionValue
                    self.motions.value.append(motionValue)
                    if self.motions.value.count == Constant.maxCount {
                        self.measerStop(type: .accelerometer)
                    }
                }
            })
            coreMotionManager.startUpdates(type: .gyro)
        case .accelerometer:
            coreMotionManager.bind(accHandler: { data, error in
                if let data = data {
                    let motionValue = MotionValue(data)
                    self.currentMotion.value = motionValue
                    self.motions.value.append(motionValue)
                    if self.motions.value.count == Constant.maxCount {
                        self.measerStop(type: .accelerometer)
                    }
                }
            })
            coreMotionManager.startUpdates(type: .accelerometer)
        }
    }
    
    func measerStop(type: MotionType) {
        status.value = .stop
        switch type {
        case .gyro:
            coreMotionManager.stopUpdates(type: .gyro)
        case .accelerometer:
            coreMotionManager.stopUpdates(type: .accelerometer)
        }
    }
    
    func measerSave(type: MotionType) throws {
        status.value = .ready
        let timeInterval = TimeInterval( Double(motions.value.count) * 0.1)
        let saveData = Motion(uuid: UUID(), type: type, values: motions.value, date: Date(), duration: timeInterval)
        storage.insert(saveData)
        try MotionFileManager.shared.save(data: saveData.toFile())
    }
    
    func measerCancle(type: MotionType) {
        switch type {
        case .gyro:
            coreMotionManager.stopUpdates(type: .gyro)
        case .accelerometer:
            coreMotionManager.stopUpdates(type: .accelerometer)
        }
        motions.value = []
        status.value = .ready
        currentMotion.value = nil
    }
}
