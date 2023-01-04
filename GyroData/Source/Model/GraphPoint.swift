//
//  GraphPoint.swift
//  GyroData
//
//  Created by 유한석 on 2022/12/28.
//

import Foundation

// gyro와 acc의 xyz를 저장하기 위한 모델
struct GraphPoint {
    var xValue: CGFloat
    var yValue: CGFloat
    var zValue: CGFloat
    
    init(_ xValue: CGFloat, _ yValue: CGFloat, _ zValue: CGFloat) {
        self.xValue = xValue
        self.yValue = yValue
        self.zValue = zValue
    }
}
