//
//  SceneDelegate.swift
//  GyroData
//
//  Created by Ayaan, Wonbi on 2023/01/30.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        
        let coreDataRepository = DefaultCoreDataRepository()
        let fileManagerRepository = DefaultFileManagerRepository()
        
        let coreDataReadService = CoreDataMotionReadService(coreDataRepository: coreDataRepository)
        let motionDeleteService = MotionDeleteService(
            coreDataRepository: coreDataRepository,
            fileManagerRepository: fileManagerRepository
        )
        
        let motionsListViewModel = MotionsListViewModel(
            readService: coreDataReadService,
            deleteService: motionDeleteService
        )
        
        let rootViewController = MotionsListViewController(viewModel: motionsListViewModel)
        let navigationController = UINavigationController(rootViewController: rootViewController)
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window
    }
}
