//
//  MeasurementManager.swift
//  GyroData
//
//  Created by ash and som on 2023/01/31.
//

import CoreMotion
import UIKit

final class MeasurementManager {
    private let motionManager = CMMotionManager()
    private var timer: Timer?
    private var timeCount = Double.zero

    private init() {
        motionManager.accelerometerUpdateInterval = 0.1
        motionManager.gyroUpdateInterval = 0.1
    }

    func start(_ graphMode: GraphMode, _ view: UIView, _ completionHandler: @escaping () -> Void) {
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

            drawMotionGraph(graphMode, view)
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

    private func drawMotionGraph(_ graphMode: GraphMode, _ view: UIView) {
        let measurementData: Measurable?

        switch graphMode {
        case .gyro:
            measurementData = motionManager.gyroData?.rotationRate
        case .acc:
            measurementData = motionManager.accelerometerData?.acceleration
        }

        guard let data = measurementData else { return }

        // TODO: 그래프 뷰가 data의 x, y, z 좌표를 가지고 그려야 함!
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
