//
//  ListCellViewModel.swift
//  GyroData
//
//  Created by leewonseok on 2023/02/03.
//

import Foundation

final class ListCellViewModel {
    
    private var motionEntity: MotionEntity {
        didSet {
            cellHandler?(motionEntity)
        }
    }
    
    private var cellHandler: ((MotionEntity)->Void)?
    
    init(motionEntity: MotionEntity) {
        self.motionEntity = motionEntity
    }
    
    func bind(handler: @escaping((MotionEntity)->Void)) {
        self.cellHandler = handler
    }
    
    func load() {
        cellHandler?(motionEntity)
    }
}
