//
//  ReplayMotionViewModel.swift
//  GyroData
//
//  Created by Aaron, Gundy on 2023/01/31.
//

import Foundation

final class ReplayMotionViewModel {

    private var fileManager: FileManager
    private var motionInstance: MotionData!
    private var replayType: ReplayType
    private var currentValue: SIMD3<Double> = .zero

    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2

        return formatter
    }()

    private var motionDataForDrawing: [SIMD3<Double>] = [] {
        didSet {
            replayMotionDataHandler?()
        }
    }
    private var replayMotionDataHandler: (() -> ())?

    init(index: IndexPath, type: ReplayType) {
        self.fileManager = FileManager.shared
        self.replayType = type
        self.motionInstance = fetchMotionData(index: index.item)
    }

    func fetchMotionData(index: Int) -> MotionData {
        return fileManager.fetchData(index: index)
    }

    func bindMotionData(handler: @escaping () -> ()) {
        self.replayMotionDataHandler = handler
    }
    
    func fetchCurrentValue() -> (x: String, y: String, z: String) {
        return (formatText(currentValue.x),
                formatText(currentValue.y),
                formatText(currentValue.z))
    }

    private func formatText(_ value: Double) -> String {
        guard let text = numberFormatter.string(for: value) else {
            return value.description
        }

        return text
    }

    func bindCellData() -> (MotionData, ReplayType) {
        return (motionInstance, replayType)
    }

    func setUpMotionDataForDrawing(index: Int) {
        currentValue = motionInstance.value[index]
        motionDataForDrawing.append(.init(x: currentValue.x, y: currentValue.y, z: currentValue.z))
    }

    func cleanGraph() {
        motionDataForDrawing = []
    }
}

extension ReplayMotionViewModel: GraphViewDataSource {

    func dataList(graphView: GraphView) -> [[Double]] {
        switch replayType {
        case .view:
            let xValues: [Double] = motionInstance.value.map({ $0.x })
            let yValues: [Double] = motionInstance.value.map({ $0.y })
            let zValues: [Double] = motionInstance.value.map({ $0.z })

            return [xValues, yValues, zValues]
        case .play:
            let xValues: [Double] = motionDataForDrawing.map({ $0.x })
            let yValues: [Double] = motionDataForDrawing.map({ $0.y })
            let zValues: [Double] = motionDataForDrawing.map({ $0.z })

            return [xValues, yValues, zValues]
        }
    }

    func maximumXValueCount(graphView: GraphView) -> CGFloat {
        return CGFloat(motionInstance.value.count)
    }
}
