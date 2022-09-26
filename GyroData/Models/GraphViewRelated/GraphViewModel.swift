//
//  GraphViewModel.swift
//  GyroData
//
//  Created by pablo.jee on 2022/09/26.
//

import Foundation

class GraphViewModel {
    
    //input
    var didReceiveData: ([MotionMeasure]) -> () = { measure in }
    var didReceiveRemoveAll = { }
    
    //output
    var dataSource: [ValueInfo] {
        return privateDataSource
    }
    
    var populateData: () -> () = { }
    var populateRemoveAll = { }
    
    //properties
    private var privateDataSource: [ValueInfo] = []
    
    init() {
        bind()
    }
    
    func bind() {
        didReceiveData = { [weak self] measure in
            guard let calculatedValue = self?.calculateValue(value: measure) else { return }
            
            self?.privateDataSource = calculatedValue
            self?.populateData()
        }
        
        didReceiveRemoveAll = { [weak self] in
            self?.privateDataSource.removeAll()
            self?.populateRemoveAll()
        }
    }
    
    //Gyro, acc 값의 최소, 최대값은 0.0 ~ 1.0 으로 추정
    //그러므로 ViewModel에서 "그래프가 표시할 수 있는 정도의 값"으로 보정을 해야함
    //TODO: 실제 데이터와 연결하면서 더 나은 데이터 범위로 나오도록 보정
    private func calculateValue(value: [MotionMeasure]) -> [ValueInfo] {
        var newValue: [ValueInfo] = value.map { measure in
            //0.0~100.0
            var valueInfo = ValueInfo(xValue: 0, yValue: 0, zValue: 0)
            valueInfo.xValue = measure.x * 50.0 * 2
            valueInfo.yValue = measure.y * 50.0 * 2
            valueInfo.zValue = measure.z * 50.0 * 2
            return valueInfo
        }
        return newValue
    }
}

struct ValueInfo {
    var xValue: CGFloat
    var yValue: CGFloat
    var zValue: CGFloat
}


