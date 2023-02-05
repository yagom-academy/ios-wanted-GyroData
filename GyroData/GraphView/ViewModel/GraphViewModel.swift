//
//  GraphViewModel.swift
//  GyroData
//
//  Created by junho lee on 2023/02/05.
//

import Foundation

final class GraphViewModel {
    enum Action {
        case updateGraph(coordinate: Coordinate, handler: (Coordinate) -> Void)
        case drawCompleteGraph(with: [Coordinate])
        case configureAxisRange(with: [Coordinate])
    }

    private var drawCompleteGraph: (([Coordinate]) -> Void)?
    private var coordinates = [Coordinate]()
    var maxValue = 5.0
    var count = 1.0
    let maxCount = 600.0

    private func axisRangeNeedsUpdate(_ coordinate: Coordinate) {
        var maxValue = max(coordinate.x, coordinate.y, coordinate.z)
        let minValue = min(coordinate.x, coordinate.y, coordinate.z)
        maxValue = max(maxValue, abs(minValue))
        if maxValue > self.maxValue {
            self.maxValue = maxValue
            drawCompleteGraph?(coordinates)
        }
    }
    
    private func updateMaxValue(_ coordinates: [Coordinate]) {
        for coordinate in coordinates {
            if coordinate.x > maxValue { maxValue = coordinate.x }
            if coordinate.y > maxValue { maxValue = coordinate.y }
            if coordinate.z > maxValue { maxValue = coordinate.z }
        }
    }
    
    func action(_ action: Action) {
        switch action {
        case let .updateGraph(coordinate, handler):
            coordinates.append(coordinate)
            axisRangeNeedsUpdate(coordinate)
            handler(coordinate)
        case let .drawCompleteGraph(coordinates):
            self.coordinates = coordinates
            updateMaxValue(coordinates)
            drawCompleteGraph?(coordinates)
        case let .configureAxisRange(coordinates):
            updateMaxValue(coordinates)
        }
    }

    func bind(drawCompleteGraph: @escaping ([Coordinate]) -> Void) {
        self.drawCompleteGraph = drawCompleteGraph
    }
}
