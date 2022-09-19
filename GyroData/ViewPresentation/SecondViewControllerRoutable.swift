//
//  SecondViewControllerRoutable.swift
//  GyroData
//
//  Created by pablo.jee on 2022/09/20.
//

import Foundation
import UIKit

protocol SecondViewControllerRoutable: Routable, SecondViewControllerSceneBuildable {
    
}

extension SecondViewControllerRoutable where Self: SecondViewController {
    func buildScene(scene: SceneCategory) -> Scenable? {
        var nextScene: Scenable?
        switch scene {
        case .detail(.thirdViewController):
            nextScene = buildThirdScene()
        default: break
        }
        return nextScene
    }
    
    func route(to Scene: SceneCategory) {
        switch Scene {
        case .detail(.thirdViewController):
            let nextScene = buildScene(scene: Scene)
            guard let nextVC = nextScene as? UIViewController else { return }
            self.navigationController?.pushViewController(nextVC, animated: true)
        default: break
        }
    }
}

protocol SecondViewControllerSceneBuildable: SceneBuildable {
    
}

extension SecondViewControllerSceneBuildable {
    func buildThirdScene() -> Scenable {
        var nextScene: Scenable
        
        let thirdVC = ThirdViewController()
        nextScene = thirdVC
        
        return nextScene
    }
}
