//
//  ThirdViewControllerRoutable.swift
//  GyroData
//
//  Created by 한경수 on 2022/09/21.
//

import Foundation
import UIKit

protocol ThirdViewControllerRoutable: Routable {
    
}

extension ThirdViewControllerRoutable where Self: ThirdViewController {
    func route(to Scene: SceneCategory) {
        switch Scene {
        case .close:
            self.navigationController?.popViewController(animated: true)
        default: break
        }
    }
}
