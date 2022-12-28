//
//  MotionResultViewModel.swift
//  GyroData
//
//  Created by 이호영 on 2022/12/29.
//

import Foundation

protocol MotionResultViewModelInput {
    func load()
}

protocol MotionResultViewModelOutput {
    var motionData: Observable<[MotionInformation]> { get }
}

protocol MotionResultViewModelType: MotionResultViewModelInput, MotionResultViewModelOutput { }

class MotionResultViewModel: MotionResultViewModelType {
   
    let sampleData = [MotionInformation(id: UUID(), motionType: .gyro, date: Date(), time: 60.0, xData: [1.23232323, 1.55555555, -2.434343343], yData: [0.2111112, -1.20000005555, 1.434343343], zData: [-1.23232323, 3.001115555, 2.434343343])]
    
    init(_ motion: Motion) {
        self.motionId = motion.id
    }
    
    /// Output
    
    var motionId: UUID?
    var motionData: Observable<[MotionInformation]> = Observable([])
    
    /// Input
    
    func load() {
        // id 가지고 fileManager 접근
        // 가지고 온 데이터 motionData에 Set
        motionData.value = sampleData
    }
    
}
