//
//  GraphViewModel.swift
//  GyroData
//
//  Created by 써니쿠키 on 2023/02/04.
//

import Foundation

final class GraphViewModel {

    private(set) var axisValues: [AxisValue] = [] {
        didSet {
            update()
        }
    }

    private var update: () -> Void = {}

    var numberOfAxisValues: Int {
        return axisValues.count
    }

    func bindingUpdate(update: @escaping () -> Void) {
        self.update = update
    }

    func setAxisValues(_ axisValues: [AxisValue]) {
        self.axisValues = axisValues
    }

    func addAxisValue(_ axisValue: AxisValue) {
        self.axisValues.append(axisValue)
    }
}
