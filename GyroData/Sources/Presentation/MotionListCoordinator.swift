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
        let viewController = makeMotionListViewController()
        navigationController.pushViewController(viewController, animated: true)
    }
}

private extension MotionListCoordinator {
    func makeMotionListViewController() -> UIViewController {
        let viewController = MotionListViewController(
            viewModel: MotionListViewModel(),
            coordinator: self
        )
        viewController.coordinator = self
        return viewController
    }
    
    func makeMotionMeasureViewController() -> UIViewController {
        let viewController = UIViewController()
        return viewController
    }
    
    func makeMotionDetailViewController() -> UIViewController {
        let viewController = UIViewController()
        return viewController
    }
}

extension MotionListCoordinator: MotionListCoordinatorInterface {
    
    func showMotionMeasureView() {
        let viewController = makeMotionMeasureViewController()
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showMotionDetailView() {
        let viewController = makeMotionDetailViewController()
        navigationController.pushViewController(viewController, animated: true)
    }
    
}
