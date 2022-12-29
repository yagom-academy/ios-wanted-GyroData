//
//  MotionListCoordinatorInterface.swift
//  GyroData
//
//  Created by Ari on 2022/12/27.
//

import Foundation

protocol MotionListCoordinatorInterface: AnyObject {
    
    func showMotionMeasureView()
    func showMotionDetailView()
    func showMotionPlayView()
    func popViewController()
    
}
