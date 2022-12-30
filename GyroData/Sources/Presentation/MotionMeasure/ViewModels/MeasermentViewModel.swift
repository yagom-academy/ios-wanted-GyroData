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
    var errorMessage: Observable<String?> { get }
    var isLoading: Observable<Bool> { get }
    
}

protocol MeasermentViewModel: MeasermentViewModelInput, MeasermentViewModelOutput {}

enum MeasermentStatus {
    case ready, start, stop, done
}

final class DefaultMeasermentViewModel: MeasermentViewModel {
    
    private enum Constant {
        static let maxCount = 600
    }
    
    private let storage: MotionStorage
    private let coreMotionManager: CoreMotionManager
    
    init(
        manger: CoreMotionManager = CoreMotionManager(),
        storage: MotionStorage = CoreDataMotionStorage()
    ) {
        self.coreMotionManager = manger
        self.storage = storage
    }
    
    // MARK: - Output
    var motions: Observable<[MotionValue]> = .init([])
    var status: Observable<MeasermentStatus> = .init(.ready)
    var currentMotion: Observable<MotionValue?> = .init(nil)
    var errorMessage: Observable<String?> = .init(nil)
    var isLoading: Observable<Bool> = .init(false)
    
    // MARK: - Input
    func measerStart(type: MotionType) {
        status.value = .start
        switch type {
        case .gyro:
            coreMotionManager.bind(gyroHandler: { [weak self] data, _ in
                guard let self else {
                    return
                }
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
            coreMotionManager.bind(accHandler: { [weak self] data, _ in
                guard let self else {
                    return
                }
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
    
    func measerSave(type: MotionType) {
        isLoading.value = true
        DispatchQueue.global().async { [weak self] in
            guard let self else {
                return
            }
            let timeInterval = TimeInterval( Double(self.motions.value.count) * 0.1)
            let saveData = Motion(
                uuid: UUID(),
                type: type, 
                values: self.motions.value, 
                date: Date(), 
                duration: timeInterval
            )
            self.storage.insert(saveData)
            do {
                try MotionFileManager.shared.save(data: saveData.toFile())
                self.status.value = .done
            } catch {
                self.errorMessage.value = error.localizedDescription
            }
            self.isLoading.value = false
        }
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
