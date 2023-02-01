//  GyroData - SceneDelegate.swift
//  Created by zhilly, woong on 2023/01/31

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let MeasureListViewController = MeasureListViewController()
        let navigationController = UINavigationController(rootViewController: MeasureListViewController)
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navigationController
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
    }
}
