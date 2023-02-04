//
//  GraphViewModel.swift
//  GyroData
//
//  Created by Aejong on 2023/02/04.
//

final class GraphViewModel {
    typealias MotionMeasuresHandler = (MotionCoordinate) -> Void
    
    private var motionCoordinate: MotionCoordinate? {
        didSet {
            guard let motionCoordinate = motionCoordinate else { return }
            graphDataHandler?(motionCoordinate)
        }
    }
    
    private var graphDataHandler: MotionMeasuresHandler?
    
    func bindGraphData(_ handler: @escaping MotionMeasuresHandler) {
        graphDataHandler = handler
    }
    
    func setCoordinate(_ motionMeasures: MotionCoordinate) {
        self.motionCoordinate = motionMeasures
    }
}
