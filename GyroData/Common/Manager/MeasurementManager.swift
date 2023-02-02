//
//  MeasurementManager.swift
//  GyroData
//
//  Created by ash and som on 2023/01/31.
//

import CoreMotion
import Foundation

final class MeasurementManager {
    static let shared: MeasurementManager = MeasurementManager()
    private let motionManager = CMMotionManager()
    private var timer: Timer?
    var timeCount = Double.zero

    private init() {
        motionManager.accelerometerUpdateInterval = 0.1
        motionManager.gyroUpdateInterval = 0.1
    }

    func start(_ graphMode: GraphMode, _ graphView: GraphView, _ completionHandler: @escaping () -> Void) {
        timeCount = Double.zero

        checkAvailable(to: graphMode)

        timer = Timer(fire: Date(),
                      interval: 0.1,
                      repeats: true,
                      block: { [self] watch in
            timeCount += 0.1

            if checkTime(value: timeCount) {
                watch.invalidate()
                completionHandler()
            }

            drawMotionGraph(graphMode, graphView)
        })

        if let timer = timer {
            RunLoop.current.add(timer, forMode: .default)
        }
    }

    func checkAvailable(to graphMode: GraphMode) {
        switch graphMode {
        case .gyro:
            guard motionManager.isGyroAvailable else { return }
        case .acc:
            guard motionManager.isAccelerometerAvailable else { return }
        }

        motionManager.startGyroUpdates()
    }

    private func checkTime(value: Double) -> Bool {
        return round(value * 10) / 10 == 60.0
    }

    private func drawMotionGraph(_ graphMode: GraphMode, _ graphView: GraphView) {
        let measurementData: Measurable?

        switch graphMode {
        case .gyro:
            measurementData = motionManager.gyroData?.rotationRate
        case .acc:
            measurementData = motionManager.accelerometerData?.acceleration
        }

        guard let data = measurementData else { return }

        graphView.add([data.x, data.y, data.z])
    }

    func stop(_ graphMode: GraphMode) {
        guard let currentTimer = timer else { return }

        currentTimer.invalidate()
        timer = nil

        switch graphMode {
        case .gyro:
            motionManager.stopGyroUpdates()
        case .acc:
            motionManager.stopAccelerometerUpdates()
        }
    }
}
