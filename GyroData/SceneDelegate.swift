//
//  SceneDelegate.swift
//  GyroData
//
//  Created by 백곰, 바드 on 2022/09/16.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    // MARK: Properties
    
    var window: UIWindow?
    
    // MARK: - Methods
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let mainViewController = ViewController()
        let naviagtionController = UINavigationController(
            rootViewController: mainViewController
        )
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = naviagtionController
        window?.makeKeyAndVisible()
    }
}
