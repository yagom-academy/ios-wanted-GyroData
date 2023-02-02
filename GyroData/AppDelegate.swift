//
//  AppDelegate.swift
//  GyroData
//
//  Created by kjs on 2022/09/16.
//


import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    enum ConfigurationLiterals {
        static let defaultConfiguration = "Default Configuration"
    }

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {

        return UISceneConfiguration(
            name: ConfigurationLiterals.defaultConfiguration,
            sessionRole: connectingSceneSession.role
        )
    }

    func application(
        _ application: UIApplication,
        didDiscardSceneSessions sceneSessions: Set<UISceneSession>
    ) { }


}

