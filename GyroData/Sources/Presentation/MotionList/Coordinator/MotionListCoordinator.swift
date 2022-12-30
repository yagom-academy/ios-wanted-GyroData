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
    
    private weak var listDelegate: MotionListViewControllerDelegate?
    
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
        listDelegate = viewController
        return viewController
    }
    
    private func makeMotionMeasureViewController() -> UIViewController {
        let viewController = MeasurementViewController(viewModel: DefaultMeasermentViewModel(), coordinator: self)
        return viewController
    }
    
    private func makeMotionDetailViewController(motionEntity: MotionEntity) -> UIViewController {
        let viewController = MotionPlayViewController(
            viewModel: DefaultMotionPlayViewModel(
                motionEntity: motionEntity,
                viewType: .view
            )
        )
        return viewController
    }
    
    private func makeMotionPlayViewController(motionEntity: MotionEntity) -> UIViewController {
        let viewController = MotionPlayViewController(
            viewModel: DefaultMotionPlayViewModel(
                motionEntity: motionEntity,
                viewType: .play
            )
        )
        return viewController
    }
    
}

extension MotionListCoordinator: MotionListCoordinatorInterface {
    
    func showMotionMeasureView() {
        let viewController = makeMotionMeasureViewController()
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showMotionDetailView(motionEntity: MotionEntity) {
        let viewController = makeMotionDetailViewController(motionEntity: motionEntity)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showMotionPlayView(motionEntity: MotionEntity) {
        let viewController = makeMotionPlayViewController(motionEntity: motionEntity)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func popViewController() {
        navigationController.popViewController(animated: true)
        listDelegate?.update()
    }
    
}
