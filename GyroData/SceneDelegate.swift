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
        window?.rootViewController = SplashViewController()
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            guard let self = self else { return }
            self.window?.overrideUserInterfaceStyle = .dark
            self.window?.rootViewController = UINavigationController(rootViewController: AnalyzeListViewController())
            self.window?.makeKeyAndVisible()
        }
    }
}
