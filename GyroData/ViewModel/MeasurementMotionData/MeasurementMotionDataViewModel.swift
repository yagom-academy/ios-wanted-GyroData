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

extension MeasurementMotionDataViewModel: GraphViewDataSource {
    
    func dataList(graphView: GraphView) -> [[Double]] {
        let xValues: [Double] = motionData.map({ $0.x })
        let yValues: [Double] = motionData.map({ $0.y })
        let zValues: [Double] = motionData.map({ $0.z })
        
        return [xValues, yValues, zValues]
    }
    
    func maximumXValueCount(graphView: GraphView) -> CGFloat {
        return CGFloat(maximumValueCount)
    }
}

extension MeasurementMotionDataViewModel: MotionDataManageable {
    
    func startUpdates(_ motion: MotionType) {
        reset()
        switch motion {
        case .accelerometer:
            motionManager.startAccelerometerUpdates(to: .main) { [weak self] data, _ in
                guard let count =  self?.motionData.count,
                      let maximumCount = self?.maximumValueCount,
                      count < maximumCount else {
                    self?.motionManager.stopAccelerometerUpdates()
                    return
                }
                if let data = data?.acceleration {
                    let value: SIMD3<Double> = .init(x: data.x, y: data.y, z: data.z)
                    self?.currentValue = value
                    self?.motionData.append(value)
                }
            }
        case .gyro:
            motionManager.startGyroUpdates(to: .main) { [weak self] data, _ in
                guard let count =  self?.motionData.count,
                      let maximumCount = self?.maximumValueCount,
                      count < maximumCount else {
                    self?.motionManager.stopGyroUpdates()
                    return
                }
                if let data = data?.rotationRate {
                    let value: SIMD3<Double> = .init(x: data.x, y: data.y, z: data.z)
                    self?.currentValue = value
                    self?.motionData.append(value)
                }
            }
        }
    }
}
