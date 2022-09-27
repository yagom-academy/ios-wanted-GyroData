//
//  GraphViewModel.swift
//  GyroData
//
//  Created by pablo.jee on 2022/09/26.
//

import Foundation

class GraphViewModel {
    
    //input
    var didReceiveTickData: ([MotionMeasure]) -> () = { measure in } //데이터가 한 틱씩 들어오는 경우. ex. 실시간측정 + playType
    var didReceiveWholePacketData: ([MotionMeasure]) -> () = { measure in } //한번에 모든 데이터가 들어오는 경우. ex. viewType
    var didReceiveRemoveAll = { }
    
    //output
    var dataSource: [ValueInfo] {
        return privateDataSource
    }
    
    var populateTickData: () -> () = { }
    var populateWholePacketData = { }
    var populateRemoveAll = { }
    
    //properties
    private var privateDataSource: [ValueInfo] = []
    
    init() {
        bind()
    }
    
    func bind() {
        //ThirdModel의 ViewType을 GraphViewModel이 알고 있는 것은 좋지 못한 발상으로 보인다.
        //GraphViewModel은 인터페이스만 뚫어놓고 그 인터페이스의 사용 여부는 ThirdModel, SecondModel이 알아서 결정하게 해야 한다
        
        //데이터가 한 틱씩 들어오는 경우. ex. 실시간측정 + playType
        didReceiveTickData = { [weak self] measure in
            guard let calculatedValue = self?.calculateValue(value: measure) else { return }
            self?.privateDataSource = calculatedValue
            self?.populateTickData()
        }
        
        //한번에 모든 데이터가 들어오는 경우. ex. viewType
        didReceiveWholePacketData = { [weak self] measure in
            guard let calculatedValue = self?.calculateValue(value: measure) else { return }
            self?.privateDataSource = calculatedValue
            self?.populateWholePacketData()
        }
        
        didReceiveRemoveAll = { [weak self] in
            self?.privateDataSource.removeAll()
            self?.populateRemoveAll()
        }
    }
    
    //그러므로 ViewModel에서 "그래프가 표시할 수 있는 정도의 값"으로 보정을 해야함
    private func calculateValue(value: [MotionMeasure]) -> [ValueInfo] {
        let newValue: [ValueInfo] = value.map { measure in
            //TODO: 실제 데이터와 연결하면서 더 나은 데이터 범위로 나오도록 보정
            var valueInfo = ValueInfo(xValue: 0, yValue: 0, zValue: 0)
            valueInfo.xValue = measure.x * 100
            valueInfo.yValue = measure.y * 100
            valueInfo.zValue = measure.z * 100
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


