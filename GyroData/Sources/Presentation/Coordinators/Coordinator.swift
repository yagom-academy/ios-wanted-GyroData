//
//  Coordinator.swift
//  GyroData
//
//  Created by Ari on 2022/12/27.
//

import UIKit

protocol Coordinator: AnyObject {
    
    var parentCoordinator: Coordinator? { get set }
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }

    func start()

}
