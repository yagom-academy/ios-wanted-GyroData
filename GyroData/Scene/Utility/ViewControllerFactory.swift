//
//  ViewControllerFactory.swift
//  GyroData
//
//  Created by Wonbi on 2023/02/03.
//

import UIKit

enum ControllerType {
    case list
    case measurement
    case graph(style: MotionGraphViewController.Style, id: String)
}

enum ViewControllerFactory {
    static func makeViewController(type: ControllerType) -> UIViewController {
        switch type {
        case .list:
            return makeListViewController()
        case .measurement:
            return makeMeasurementViewController()
        case .graph(let style, let id):
            return makeGraphViewController(style: style, id: id)
        }
    }
    
    static private func makeListViewController() -> MotionsListViewController {
        let coreDataRepository = DefaultCoreDataRepository()
        let fileManagerRepository = DefaultFileManagerRepository()
        
        let coreDataReadService = CoreDataMotionReadService(coreDataRepository: coreDataRepository)
        let motionDeleteService = MotionDeleteService(
            coreDataRepository: coreDataRepository,
            fileManagerRepository: fileManagerRepository
        )
        
        let motionsListViewModel = MotionsListViewModel(
            readService: coreDataReadService,
            deleteService: motionDeleteService
        )
        
        let motionsListViewController = MotionsListViewController(viewModel: motionsListViewModel)
        return motionsListViewController
    }
    
    static private func makeMeasurementViewController() -> MotionMeasureViewController {
        let coreDataRepository = DefaultCoreDataRepository()
        let fileManagerRepository = DefaultFileManagerRepository()
        
        let motionCreateService = MotionCreateService(
            coreDataRepository: coreDataRepository,
            fileManagerRepository: fileManagerRepository
        )
        let motionMeasurementService = MotionMeasurementService()
            
        let motionMeasurementViewModel = MotionMeasurementViewModel(
            createService: motionCreateService,
            measurementService: motionMeasurementService
        )
        
        let motionMeasureViewController = MotionMeasureViewController(viewModel: motionMeasurementViewModel)
        return motionMeasureViewController
    }
    
    static private func makeGraphViewController(style: MotionGraphViewController.Style, id: String) -> MotionGraphViewController {
        let fileManagerRepository = DefaultFileManagerRepository()
        
        let fileManagerReadService = FileManagerMotionReadService(repository: fileManagerRepository)
        
        let motionViewModel = MotionGraphViewModel(motionID: id, readService: fileManagerReadService)
        
        let motionGraphViewController = MotionGraphViewController(style: style, viewModel: motionViewModel)
        return motionGraphViewController
    }
}
