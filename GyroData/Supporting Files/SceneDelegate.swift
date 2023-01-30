//
//  SceneDelegate.swift
//  GyroData
//
//  Created by 써니쿠키, 로빈 on 2022/09/16.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)

        let rootViewController = ViewController()
        let navigationController = UINavigationController(rootViewController: rootViewController)

        window?.rootViewController = navigationController
        window?.backgroundColor = .systemBackground
        window?.makeKeyAndVisible()
    }
}
