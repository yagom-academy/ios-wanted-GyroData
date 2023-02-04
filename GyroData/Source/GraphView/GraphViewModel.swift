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
    private var resetHandler: (() -> Void)?
    
    func bindGraphData(_ handler: @escaping MotionMeasuresHandler) {
        graphDataHandler = handler
    }
    
    func bindResetHandler(_ handler: @escaping (() -> Void)) {
        resetHandler = handler
    }
    
    func drawCoordinate(_ motionCoordinate: MotionCoordinate) {
        self.motionCoordinate = motionCoordinate
    }
    
    func drawAll(_ motionMeasures: MotionMeasures) {
        var axisX = Array(motionMeasures.axisX.reversed())
        var axisY = Array(motionMeasures.axisY.reversed())
        var axisZ = Array(motionMeasures.axisZ.reversed())
        
        for _ in 0..<motionMeasures.axisX.count {
            guard let x = axisX.popLast(),
                  let y = axisY.popLast(),
                  let z = axisZ.popLast()
            else {
                return
            }
            
            motionCoordinate = MotionCoordinate(x: x, y: y, z: z)
        }
    }
    
    func reset() {
        resetHandler?()
    }
}
