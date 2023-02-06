//
//  GraphViewModel.swift
//  GyroData
//
//  Created by Aejong on 2023/02/04.
//

final class GraphViewModel {
    typealias MotionCoordinateHandler = (MotionCoordinate) -> Void
    
    private var motionCoordinate: MotionCoordinate? {
        didSet {
            guard let motionCoordinate = motionCoordinate else { return }
            graphCoordinateHandler?(motionCoordinate)
        }
    }
    
    private var motionMeasures: MotionMeasures? {
        didSet {
            guard let motionMeasures = motionMeasures else { return }
            graphMotionMeasuresHandler?(motionMeasures)
        }
    }
    
    private var graphCoordinateHandler: MotionCoordinateHandler?
    private var graphMotionMeasuresHandler: ((MotionMeasures) -> Void)?
    private var resetHandler: (() -> Void)?
    
    func bindGraphCoordinate(_ handler: @escaping MotionCoordinateHandler) {
        graphCoordinateHandler = handler
    }
    
    func bindGraphMotionMeasures(_ handler: @escaping (MotionMeasures) -> Void) {
        graphMotionMeasuresHandler = handler
    }
    
    func bindResetHandler(_ handler: @escaping (() -> Void)) {
        resetHandler = handler
    }
    
    func drawCoordinate(_ motionCoordinate: MotionCoordinate) {
        self.motionCoordinate = motionCoordinate
    }
    
    func drawAll(_ motionMeasures: MotionMeasures) {
        self.motionMeasures = motionMeasures
    }
    
    func reset() {
        resetHandler?()
    }
}
