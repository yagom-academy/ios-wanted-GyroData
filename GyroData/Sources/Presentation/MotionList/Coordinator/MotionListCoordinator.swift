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
        viewController.coordinator = self
        return viewController
    }
    
    private func makeMotionMeasureViewController() -> UIViewController {
        let viewController = MeasurementViewController(viewModel: DefaultMeasermentViewModel())
        return viewController
    }
    
    private func makeMotionDetailViewController(motionEntity: MotionEntity) -> UIViewController {
        let viewController = MotionPlayViewController(viewModel: DefaultMotionPlayViewModel(motionEntity: motionEntity, viewType: .view))
        return viewController
    }
    
    private func makeMotionPlayViewController(motionEntity: MotionEntity) -> UIViewController {
        let viewController = MotionPlayViewController(viewModel: DefaultMotionPlayViewModel(motionEntity: motionEntity, viewType: .play))
        return viewController
    }
    
}

extension MotionListCoordinator: CoordinatorFinishDelegate {
    
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        childCoordinators = childCoordinators.filter({ $0.type != childCoordinator.type })
        
        switch childCoordinator.type {
        case .motionDataAdd:
            childDidFinish(childCoordinator, parent: self)
            
        default: return
        }
    }
    
}

extension MotionListCoordinator: MotionListCoordinatorInterface {
    
    func showMotionMeasureView() {
        let viewController = makeMotionMeasureViewController()
        viewController.modalPresentationStyle = .fullScreen
        navigationController.visibleViewController?.present(viewController, animated: true)
    }
    
    func showMotionDetailView(motionEntity: MotionEntity) {
        let viewController = makeMotionDetailViewController(motionEntity: motionEntity)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showMotionPlayView(motionEntity: MotionEntity) {
        let viewController = makeMotionPlayViewController(motionEntity: motionEntity)
        navigationController.pushViewController(viewController, animated: true)
    }
    
}
