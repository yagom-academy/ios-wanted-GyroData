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
        return Coordiante(x: Double.random(in: -5000...5000),
                          y: Double.random(in: -1500...5000),
                          z: Double.random(in: -5000...1500))
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {


        var randomCoordinates = [Coordiante]()
        for _ in 0..<100 {
            randomCoordinates.append(randomCoordinate)
        }

        let record = MotionRecord(id: UUID(), startDate: Date(),
                                  msInterval: 10, motionMode: .accelerometer,
                                  coordinates: randomCoordinates)
        let vc = MotionReplayViewController(replayType: .view, motionRecord: record)

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: vc)
        window?.makeKeyAndVisible()
        return true
    }
}

