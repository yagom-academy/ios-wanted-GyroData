//
//  FirstViewControllerRoutable.swift
//  GyroData
//
//  Created by pablo.jee on 2022/09/20.
//

import Foundation
import UIKit

protocol FirstViewControllerRoutable: Routable, FirstViewControllerSceneBuildable {
    
}

extension FirstViewControllerRoutable where Self: FirstViewController {
    func buildScene(scene: SceneCategory) -> Scenable? {
        var nextScene: Scenable?
        switch scene {
        case .detail(.secondViewController(let context)):
            nextScene = buildSecondScene(context: context)
        case .detail(.thirdViewController(let context)):
            nextScene = buildThirdScene(context: context)
        default: break
        }
        return nextScene
    }
    
    func route(to Scene: SceneCategory) {
        switch Scene {
        case .detail(.secondViewController):
            let nextScene = buildScene(scene: Scene)
            guard let nextVC = nextScene as? UIViewController else { return }
            self.navigationController?.pushViewController(nextVC, animated: true)
        case .detail(.thirdViewController):
            let nextScene = buildScene(scene: Scene)
            guard let nextVC = nextScene as? UIViewController else { return }
            self.navigationController?.pushViewController(nextVC, animated: true)
        default: break
        }
    }
}

protocol FirstViewControllerSceneBuildable: SceneBuildable {
    
}

extension FirstViewControllerSceneBuildable {
    func buildSecondScene(context: SceneContext<SecondModel>) -> Scenable {
        var nextScene: Scenable
        let secondModel = context.dependency
        let secondVC = SecondViewController(viewModel: secondModel)
        nextScene = secondVC
        
        return nextScene
    }
    
    func buildThirdScene(context: SceneContext<ThirdModel>) -> Scenable {
        var nextScene: Scenable
        let model = context.dependency
        let thirdVC = ThirdViewController(viewModel: model)
        nextScene = thirdVC
        
        return nextScene
    }
}

