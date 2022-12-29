//
//  SceneDelegate.swift
//  GyroData
//
//  Created by unchain, Ellen J, yeton on 2022/09/16.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        window?.overrideUserInterfaceStyle = .dark
        window?.rootViewController = UINavigationController(rootViewController: AnalyzeListViewController())
        window?.makeKeyAndVisible()
    }
}

