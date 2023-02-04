//
//  DetailViewModel.swift
//  GyroData
//
//  Created by Aejong on 2023/02/03.
//

import Foundation

final class DetailViewModel {
    typealias StringHandler = (String) -> Void
    typealias MotionMeasuresHandler = ([CGFloat], [CGFloat], [CGFloat]) -> Void
    
    private let model: MotionData
    private let currentType: PageType
    
    private var date: String = String() {
        didSet {
            dateHandler?(date)
        }
    }
    private var pageType: String = String() {
        didSet {
            pageTypeHandler?(pageType)
        }
    }
    
    private var dateHandler: StringHandler?
    private var pageTypeHandler: StringHandler?
    private var graphDataHandler: MotionMeasuresHandler?
    
    init(_ motionData: MotionData, by type: PageType) {
        model = motionData
        currentType = type
    }
    
    func convertModelData() {
        date = DateFormatter.measuredDateFormatter.string(from: model.measuredDate)
        pageType = currentType.description
    }
    
    func bindDate(_ handler: @escaping StringHandler) {
        dateHandler = handler
    }
    
    func bindPageType(_ handler: @escaping StringHandler) {
        pageTypeHandler = handler
    }
    
    func bindGraphData(_ handler: @escaping MotionMeasuresHandler) {
        
    }
}

