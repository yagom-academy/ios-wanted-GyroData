//
//  MeasurementMotionDataViewModel.swift
//  GyroData
//
//  Created by Aaron, Gundy on 2023/01/31.
//

import CoreMotion
import simd

final class MeasurementMotionDataViewModel {
    
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        
        return formatter
    }()
    
    let maximumValueCount: Int = 600
    let motionManager: CMMotionManager
    private var currentValue: SIMD3<Double> = .zero
    private var motionData: [SIMD3<Double>] = [] {
        didSet {
            mesurementMotionDataHandler?()
        }
    }
    private var mesurementMotionDataHandler: (() -> ())?
    
    init(motionManager: CMMotionManager = CMMotionManager()) {
        self.motionManager = motionManager
        [MotionType.accelerometer, MotionType.gyro].forEach { motion in
            configureTimeInterval(motion, updateInterval: 0.1)
        }
    }
    
    func bindMotionData(handler: @escaping () -> ()) {
        self.mesurementMotionDataHandler = handler
    }
    
    func fetchData() -> [SIMD3<Double>] {
        return motionData
    }
    
    private func formatText(_ value: Double) -> String {
        guard let text = numberFormatter.string(for: value) else {
            return value.description
        }
        
        return text
    }
    
    func fetchCurrentValue() -> (x: String, y: String, z: String) {
        return (formatText(currentValue.x),
                formatText(currentValue.y),
                formatText(currentValue.z))
    }
    
    func reset() {
        motionData = []
    }
}
