//
//  GraphViewModel.swift
//  GyroData
//
//  Created by Aejong on 2023/02/04.
//

final class GraphViewModel {
    typealias MotionMeasuresHandler = (MotionMeasures, Double) -> Void
    
    private var motionMeasures: MotionMeasures = MotionMeasures(axisX: [], axisY: [], axisZ: []) {
        didSet {
            graphDataHandler?(motionMeasures, duration)
        }
    }
    
    private var duration: Double = Double()
    
    private var graphDataHandler: MotionMeasuresHandler?
    
    func bindGraphData(_ handler: @escaping MotionMeasuresHandler) {
        graphDataHandler = handler
    }
    
    func setMeasures(_ motionMeasures: MotionMeasures, for duration: Double) {
        self.duration = duration
        self.motionMeasures = motionMeasures
    }

}
