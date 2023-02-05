//
//  GraphViewModel.swift
//  GyroData
//
//  Created by junho lee on 2023/02/05.
//

import Foundation

final class GraphViewModel {
    enum Action {
        case drawChartLine(coordinate: Coordinate, handler: (Coordinate) -> Void)
        case fetchCoordinates(coordinates: [Coordinate])
        case configureAxisRange(coordinates: [Coordinate])
    }

    private var onRedraw: ([Coordinate]) -> Void = { _ in }
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
            onRedraw(coordinates)
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
        case let .drawChartLine(coordinate, handler):
            coordinates.append(coordinate)
            axisRangeNeedsUpdate(coordinate)
            handler(coordinate)
        case let .fetchCoordinates(coordinates):
            self.coordinates = coordinates
            updateMaxValue(coordinates) // play에서도 해야한다.
            onRedraw(coordinates)
        case .configureAxisRange(coordinates: let coordinates):
            updateMaxValue(coordinates)
        }
    }

    func bind(onRedraw: @escaping ([Coordinate]) -> Void) {
        self.onRedraw = onRedraw
    }
}
