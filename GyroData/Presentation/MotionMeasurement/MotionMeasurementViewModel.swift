//
//  MotionMeasurementViewModel.swift
//  GyroData
//
//  Copyright (c) 2023 Jeremy All rights reserved.


import Foundation

final class MotionMeasurementViewModel {
    enum UnsavedDataError: Error {
        case unSavedMeasurement
    }
    
    private let trackMotionUseCase: TrackMotionUseCase
    private var updateTrigger: ((Response) -> Void)?
    
    private var motionResponseItems: [MotionCoordinates] = [] {
        didSet {
            if let last = motionResponseItems.last {
                updateTrigger?(Response(receivedMotionData: last))
            }
        }
    }
    
    init(useCase: TrackMotionUseCase) {
        self.trackMotionUseCase = useCase
    }
    
    func bind(_ completion: @escaping (Response) -> Void ) {
        updateTrigger = completion
        completion(.init())
    }
    
    func request(_ request: Request) {
        switch request {
        case .startTrackAcceleration:
            guard isValidToProceed() else { return }
            trackMotionUseCase
                .startAccelerometer { [weak self] coordinates in
                    self?.motionResponseItems.append(coordinates)
                }
            
        case .stopTrackAcceleration:
            trackMotionUseCase.stopAccelerometer()
        case .startTrackGyro:
            guard isValidToProceed() else { return }
            trackMotionUseCase
                .startGyro { [weak self] coordinates in
                    self?.motionResponseItems.append(coordinates)
                }
        case .stopTrackGyro:
            trackMotionUseCase.stopGyro()
        case .save:
            trackMotionUseCase.stopGyro()
            trackMotionUseCase.stopAccelerometer()
        }
    }
    
    private func isValidToProceed() -> Bool {
        if !motionResponseItems.isEmpty {
            updateTrigger?(Response(error: .unSavedMeasurement))
            return false
        }
        return true
    }
}

extension MotionMeasurementViewModel {
    enum Request {
        case startTrackAcceleration
        case stopTrackAcceleration
        case startTrackGyro
        case stopTrackGyro
        case save
    }
    struct Response {
        var receivedMotionData: MotionCoordinates? = nil
        var error: UnsavedDataError? = nil
    }
}
