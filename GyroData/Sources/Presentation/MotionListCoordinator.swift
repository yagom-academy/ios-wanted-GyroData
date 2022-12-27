//
//  MotionListCoordinator.swift
//  GyroData
//
//  Created by Ari on 2022/12/27.
//

import UIKit

final class MotionListCoordinator: Coordinator {
    
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationConrtoller: UINavigationController) {
        self.navigationController = navigationConrtoller
    }
    
    func start() {
        let viewController = makeAuthViewController()
        navigationController.pushViewController(viewController, animated: true)
    }
}

private extension MotionListCoordinator {
    func makeAuthViewController() -> UIViewController {
        let viewController = MotionListViewController(
            viewModel: MotionListViewModel(),
            coordinator: self
        )
        viewController.coordinator = self
        return viewController
    }
}

extension MotionListCoordinator: MotionListCoordinatorInterface {
    
}
