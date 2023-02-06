//
//  GraphViewModel.swift
//  GyroData
//
//  Created by junho on 2023/02/05.
//

import Foundation

final class GraphViewModel {
    enum Action {
        case updateGraph(coordinate: Coordinate, handler: (Coordinate) -> Void)
        case drawCompleteGraph(with: [Coordinate])
        case configureAxisRange(with: [Coordinate])
    }

    var maxValue: Double = 5.0
    var count: Double = 1.0
    let maxCount: Double = 600.0
    private var drawCompleteGraph: (([Coordinate]) -> Void)?
    private var updateLabels: (((x: String, y: String, z: String)) -> Void)?
    private var coordinates = [Coordinate]()
    
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
            updateLabels?(convertToValues(from: coordinate))
        case let .drawCompleteGraph(coordinates):
            self.coordinates = coordinates
            updateMaxValue(coordinates)
            drawCompleteGraph?(coordinates)
            updateLabels?(convertToValues(from: coordinates.last))
        case let .configureAxisRange(coordinates):
            updateMaxValue(coordinates)
        }
    }

    func bind(_ drawCompleteGraph: @escaping ([Coordinate]) -> Void) {
        self.drawCompleteGraph = drawCompleteGraph
    }
    
    func bind(_ updateLabels: @escaping ((x: String, y: String, z: String)) -> Void) {
        self.updateLabels = updateLabels
    }
    
    private func convertToValues(from coordinate: Coordinate?) -> (x: String, y: String, z: String) {
        return (x: Int(round(coordinate?.x ?? .zero)).description,
                y: Int(round(coordinate?.y ?? .zero)).description,
                z: Int(round(coordinate?.z ?? .zero)).description)
    }
}
