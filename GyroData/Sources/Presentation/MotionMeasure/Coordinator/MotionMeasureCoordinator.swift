//
//  MotionMeasureCoordinator.swift
//  GyroData
//
//  Created by Ari on 2022/12/27.
//

import UIKit

final class MotionMeasureCoordinator: Coordinator {
    
    weak var finishDelegate: CoordinatorFinishDelegate?
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var type: CoordinatorType { .motionDataAdd }
    
    init(navigationConrtoller: UINavigationController) {
        self.navigationController = navigationConrtoller
    }
    
    func start() {
        let viewController = makeMotionMeasureViewController()
        navigationController.pushViewController(viewController, animated: true)
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
}
private extension MotionMeasureCoordinator {
    
    private func makeMotionMeasureViewController() -> UIViewController {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .white
        return viewController
    }
    
}
