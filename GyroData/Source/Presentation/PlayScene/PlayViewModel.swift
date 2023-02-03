//
//  PlayViewModel.swift
//  GyroData
//
//  Created by 이정민 on 2023/02/03.
//

import Foundation

//protocol GraphViewPlayDelegate: AnyObject {
//    func updateWasteTime(_ wasteTime: TimeInterval)
//}

class PlayViewModel {
    typealias Values = (x: Double, y: Double, z: Double)
    
    // input
    enum Action {
        case playEntireDataFlowButtonTapped
        case stopEntireDataFlowButtonTapped
    }
    
    let entireData: MeasureData
    weak var playViewDelegate: PlayViewDelegate?
    
    init(entireData: MeasureData) {
        self.entireData = entireData
    }
    
    func action(_ action: Action) {
        switch action {
        case .playEntireDataFlowButtonTapped:
            playGraph(entireData)
        case .stopEntireDataFlowButtonTapped:
            stopGraph()
        }
    }
    
    func fetchSegmentData() -> [Values] {
        var segmentValues: [Values] = []

        for i in 0..<entireData.xValue.count {
            let values: Values = (entireData.xValue[i], entireData.yValue[i], entireData.zValue[i])
            segmentValues.append(values)
        }
        
        return segmentValues
    }
}

// output
private extension PlayViewModel {
    func playGraph(_ data: MeasureData) {
        var values: [Values] = []
        
        for i in 0..<data.xValue.count {
            let data = (data.xValue[i], data.yValue[i], data.zValue[i])
            
            values.append(data)
        }
        
        playViewDelegate?.playGraphView(values)
    }
    
    func stopGraph() {
        playViewDelegate?.stopGraphView()
    }
}
