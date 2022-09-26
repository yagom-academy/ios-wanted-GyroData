//
//  Routable.swift
//  GyroData
//
//  Created by pablo.jee on 2022/09/20.
//

import Foundation
import UIKit

//모든 뷰컨트롤러는 Scenable한 프로토콜이다
protocol Scenable { }

//Scenable, 즉 뷰컨트롤러를 만들 수 있다
protocol SceneBuildable {
    func buildScene(scene: SceneCategory) -> Scenable?
}

//다른 뷰컨트롤러를 present하기 위한 가장 기본적인 메소드 호출을 할 수 있따
protocol Routable {
    func route(to Scene: SceneCategory)
}

//뷰컨트롤러가 dismiss될 수 있다
protocol SceneDismissable {
    func dismissScene(animated: Bool, completion: (() -> Void)?)
    func dismissSceneAndRefresh(sceneToRefresh: SceneCategory, animated: Bool, completion: (() -> Void)?)
    func findSceneToRefresh()
}

//SceneDismissable이 뷰컨트롤러라면 그냥 일반적인 dismiss를 한다
extension SceneDismissable where Self: UIViewController {
    func dismissScene(animated: Bool, completion: (() -> Void)?) {
        self.dismiss(animated: animated, completion: completion)
    }
}

extension UIViewController: Scenable { }
