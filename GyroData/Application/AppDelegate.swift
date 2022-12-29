//
//  AppDelegate.swift
//  GyroData
//
//  Created by kjs on 2022/09/16.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: MotionDataListViewController())
        window?.makeKeyAndVisible()

        return true
    }

    private func saveDummyDataToCoreData() {
        var randomCoordinate: Coordinate {
            return Coordinate(x: Double.random(in: -5000...5000),
                              y: Double.random(in: -1500...5000),
                              z: Double.random(in: -5000...1500))
        }

        var randomCoordinates = [Coordinate]()
        for _ in 0..<100 {
            randomCoordinates.append(randomCoordinate)
        }

        let record = MotionRecord(id: UUID(), startDate: Date(),
                                  msInterval: 10, motionMode: .accelerometer,
                                  coordinates: randomCoordinates)

        MotionRecordingStorage().saveRecord(record: record) { result in
            print(result)
        }
    }
}
