//
//  MotionCellViewModel.swift
//  GyroData
//
//  Created by inho on 2023/02/03.
//

import Foundation

final class MotionCellViewModel {
    typealias StringHandler = ((String) -> Void)
    
    private var measuredDate: String = String() {
        didSet {
            measuredDateHandler?(measuredDate)
        }
    }
    private var type: String = String() {
        didSet {
            typeHandler?(type)
        }
    }
    private var duration: String = String() {
        didSet {
            durationHandler?(duration)
        }
    }
    private var measuredDateHandler: StringHandler?
    private var typeHandler: StringHandler?
    private var durationHandler: StringHandler?
    private let motionData: MotionData
    
    init(motionData: MotionData) {
        self.motionData = motionData
    }
    
    func bindDate(_ handler: @escaping StringHandler) {
        measuredDateHandler = handler
    }
    
    func bindType(_ handler: @escaping StringHandler) {
        typeHandler = handler
    }
    
    func bindDuration(_ handler: @escaping StringHandler) {
        durationHandler = handler
    }
    
    func convertCellData() {
        measuredDate = DateFormatter.measuredDateFormatter.string(from: motionData.measuredDate)
        type = motionData.type.description
        duration = motionData.duration.description
    }
}
