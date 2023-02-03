//
//  DetailViewModel.swift
//  GyroData
//
//  Created by Aejong on 2023/02/03.
//

final class DetailViewModel {
    
    private let model: MotionData
    private let pageType: PageType
    
    init(_ motionData: MotionData, type: PageType) {
        model = motionData
        pageType = type
    }
    
    
}
