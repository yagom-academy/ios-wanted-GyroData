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
    var type: CoordinatorType { .list }
    var finishDelegate: CoordinatorFinishDelegate?
    
    init(navigationConrtoller: UINavigationController) {
        self.navigationController = navigationConrtoller
    }
    
    func start() {
        let viewController = makeMotionListViewController()
        navigationController.pushViewController(viewController, animated: true)
    }
}

private extension MotionListCoordinator {
    
    private func makeMotionListViewController() -> UIViewController {
        let viewController = MotionListViewController(
            viewModel: DefaultMotionListViewModel(),
            coordinator: self
        )
        return viewController
    }
    
    private func makeMotionMeasureViewController() -> UIViewController {
        let viewController = MeasurementViewController(
            viewModel: DefaultMeasermentViewModel(),
            coordinator: self
        )
        return viewController
    }
    
    private func makeMotionDetailViewController() -> UIViewController {
        let viewController = UIViewController()
        return viewController
    }
    
    private func makeMotionPlayViewController() -> UIViewController {
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
    
    func showMotionPlayView() {
        let viewController = makeMotionPlayViewController()
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func popViewController() {
        navigationController.popViewController(animated: true)
    }
    
}
