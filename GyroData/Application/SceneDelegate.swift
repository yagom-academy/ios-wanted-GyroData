//
//  SceneDelegate.swift
//  GyroData
//
//  Created by kjs on 2022/09/16.
//


import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let rootView = MotionLogListViewController()
        rootView.viewModel = MotionLogListViewModel()
        let rootNavigationController = UINavigationController(rootViewController: rootView)
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = rootNavigationController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) { }

    func sceneDidBecomeActive(_ scene: UIScene) { }

    func sceneWillResignActive(_ scene: UIScene) { }

    func sceneWillEnterForeground(_ scene: UIScene) { }

    func sceneDidEnterBackground(_ scene: UIScene) { }
}

