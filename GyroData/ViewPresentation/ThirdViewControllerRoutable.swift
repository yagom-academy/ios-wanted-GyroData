//
//  ThirdViewControllerRoutable.swift
//  GyroData
//
//  Created by 한경수 on 2022/09/21.
//

import Foundation
import UIKit

protocol ThirdViewControllerRoutable: Routable, SceneDismissable {
    
}
    
extension ThirdViewControllerRoutable where Self: ThirdViewController {
    func route(to Scene: SceneCategory) {
        switch Scene {
        case .close:
            print("just close")
            self.dismissScene(animated: true, completion: nil)
        case .closeAndRefresh(let scene):
            print("close and refresh")
            self.dismissSceneAndRefresh(sceneToRefresh: scene, animated: true, completion: nil)
        default: break
        }
    }
    
    func dismissSceneAndRefresh(sceneToRefresh: SceneCategory, animated: Bool, completion: (() -> Void)?) {
        switch sceneToRefresh {
        case .main(.firstViewControllerForRefresh):
            findSceneToRefresh()
        default: break
        }
    }
    
    func findSceneToRefresh() {
        guard let viewControllers = self.navigationController?.viewControllers else { return }
        for vc in viewControllers {
            if let firstVC = vc as? FirstViewController {
                firstVC.model.didReceiveRefreshRequest()
                self.navigationController?.popToViewController(firstVC, animated: true)
                print("find scene to refresh call")
                break
            }
        }
    }
}
