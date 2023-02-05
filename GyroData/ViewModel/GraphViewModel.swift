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
    }

    private var onRedraw: ([Coordinate]) ->Void = { _ in }
    private var coordinates = [Coordinate]()
    var maxValue = 5.0 {
        didSet {
            onRedraw(coordinates)
        }
    }
    var count = 1.0
    let maxCount = 600.0

    private func axisRangeNeedsUpdate(_ coordinate: Coordinate) {
        var maxValue = max(coordinate.x, coordinate.y, coordinate.z)
        let minValue = min(coordinate.x, coordinate.y, coordinate.z)
        maxValue = max(maxValue, abs(minValue))
        if maxValue > self.maxValue { self.maxValue = maxValue }
    }

    func action(_ action: Action) {
        switch action {
        case let .drawChartLine(coordinate, handler):
            coordinates.append(coordinate)
            axisRangeNeedsUpdate(coordinate)
            handler(coordinate)
        }
    }

    func bind(onRedraw: @escaping ([Coordinate]) -> Void) {
        self.onRedraw = onRedraw
    }
}
