//
//  DetailViewModel.swift
//  GyroData
//
//  Created by Aejong on 2023/02/03.
//

final class DetailViewModel {
    private let model: MotionData
    private let pageType: PageType
    
    private let title: String = "다시보기"
    
    init(_ motionData: MotionData, by type: PageType) {
        model = motionData
        pageType = type
    }
    
    
}
