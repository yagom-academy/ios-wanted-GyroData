//
//  GyroDataRepository.swift
//  GyroData
//
//  Created by 홍다희 on 2022/09/20.
//

import Foundation

final class GyroDataRepository {
    static let shared = GyroDataRepository()

    private var gyroDataList: [GyroData] = [
        .init(date: Date(), type: .acc, value: 43.4),
        .init(date: Date() + 60*60, type: .gyro, value: 60.0),
        .init(date: Date() + 60*30, type: .acc, value: 30.4),
        .init(date: Date(), type: .acc, value: 43.4),
        .init(date: Date() + 60*60, type: .gyro, value: 60.0),
        .init(date: Date() + 60*30, type: .acc, value: 30.4),
        .init(date: Date(), type: .acc, value: 43.4),
        .init(date: Date() + 60*60, type: .gyro, value: 60.0),
        .init(date: Date() + 60*30, type: .acc, value: 30.4),
        .init(date: Date(), type: .acc, value: 100.0),
        .init(date: Date(), type: .acc, value: 43.4),
        .init(date: Date() + 60*60, type: .gyro, value: 60.0),
        .init(date: Date() + 60*30, type: .acc, value: 30.4),
        .init(date: Date(), type: .acc, value: 43.4),
        .init(date: Date() + 60*60, type: .gyro, value: 60.0),
        .init(date: Date() + 60*30, type: .acc, value: 30.4),
        .init(date: Date(), type: .acc, value: 43.4),
        .init(date: Date() + 60*60, type: .gyro, value: 60.0),
        .init(date: Date() + 60*30, type: .acc, value: 30.4),
        .init(date: Date(), type: .acc, value: 200.0),
        .init(date: Date(), type: .acc, value: 43.4),
        .init(date: Date() + 60*60, type: .gyro, value: 60.0),
        .init(date: Date() + 60*30, type: .acc, value: 30.4),
        .init(date: Date(), type: .acc, value: 43.4),
        .init(date: Date() + 60*60, type: .gyro, value: 60.0),
        .init(date: Date() + 60*30, type: .acc, value: 30.4),
        .init(date: Date(), type: .acc, value: 43.4),
        .init(date: Date() + 60*60, type: .gyro, value: 60.0),
        .init(date: Date() + 60*30, type: .acc, value: 30.4),
        .init(date: Date(), type: .acc, value: 999.0),
    ]

    private init() { }

    func fetchData(firstIndex: Int, pageSize: Int) -> ArraySlice<GyroData> {
        return gyroDataList[safe: firstIndex..<(firstIndex + pageSize)]
    }
}

extension Array {
    subscript(safe range: Range<Index>) -> ArraySlice<Element> {
        return self[Swift.min(range.startIndex, self.endIndex)..<Swift.min(range.endIndex, self.endIndex)]
    }
}
