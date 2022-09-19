//
//  SceneDelegateRoutable.swift
//  GyroData
//
//  Created by pablo.jee on 2022/09/20.
//

import Foundation
import UIKit

protocol SceneDelegateRoutable: Routable, SceneDelegateSceneBuildable {
    var windowScene: UIWindowScene? { get set }
}

extension SceneDelegateRoutable where Self: SceneDelegate {
    func buildScene(scene: SceneCategory) -> Scenable? {
        var nextScene: Scenable?
        switch scene {
        case .main(.firstViewController):
            nextScene = buildFirstScene()
        default:
            break
        }
        return nextScene
    }
    
    func route(to Scene: SceneCategory) {
        guard let scene = buildScene(scene: Scene) else { return }
        setRootVCToWindow(rootVC: scene)
    }
    
    private func setRootVCToWindow(rootVC: Scenable) {
        guard let vc = rootVC as? UIViewController else { return }
        guard let windowScene = windowScene else { return }
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
    }
    
}



protocol SceneDelegateSceneBuildable: SceneBuildable {
    
}

extension SceneDelegateSceneBuildable {
    func buildFirstScene() -> Scenable {
        let firstVC = FirstViewController()
        
        let navi = UINavigationController(rootViewController: firstVC)
        
        return navi
    }
}

extension SceneDelegateSceneBuildable where Self: SceneDelegate {
    func buildScene(scene: SceneCategory) -> Scenable? {
        var nextScene: Scenable?
        switch scene {
        case .main(let mainScene):
            nextScene = buildFirstScene()
        default: break
        }
        return nextScene
    }
}
