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

    var randomCoordinate: Coordiante {
        return Coordiante(x: Double.random(in: -5...5), y: Double.random(in: -15...5), z: Double.random(in: -5...15))
    }
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {


        var randomCoordinates = [Coordiante]()
        for _ in 0..<100 {
            randomCoordinates.append(randomCoordinate)
        }

        let record = MotionRecord(id: UUID(),
                                  startDate: Date(),
                                  msInterval: 10,
                                  motionMode: .accelerometer,
                                  coordinates: randomCoordinates)

        let vc = MotionReplayViewController(replayType: .play, motionRecord: record)

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: vc)
        window?.makeKeyAndVisible()
        return true
    }
}

