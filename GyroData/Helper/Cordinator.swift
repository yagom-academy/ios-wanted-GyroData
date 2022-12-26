//
//  Cordinator.swift
//  GyroData
//
//  Created by 정재근 on 2022/12/26.
//

import UIKit

class Cordinator {
    let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let rootViewController = ListViewController()
        let navigationRootViewController = UINavigationController(rootViewController: rootViewController)
        window.rootViewController = navigationRootViewController
        window.makeKeyAndVisible()
    }
}
