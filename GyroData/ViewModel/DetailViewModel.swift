//
//  DetailViewModel.swift
//  GyroData
//
//  Created by 리지 on 2023/06/14.
//

import Foundation
import Combine

final class DetailViewModel {
    @Published private(set) var currentData: GyroEntity?
    
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"

        return dateFormatter
    }()
    
    var date: String? {
        guard let currentData = currentData,
              let date = currentData.date else { return nil }
        
        let convertedDate = dateFormatter.string(from: date)
        return convertedDate
    }

    func addData(_ data: GyroEntity) {
        currentData = data
    }
    
    func fetchData(by id: UUID) -> SixAxisDataForJSON? {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let fileName = "\(id).json"
        let fileURL = documentDirectory.appendingPathComponent("GyroData폴더").appendingPathComponent(fileName)
        return decodeJSONFile(at: fileURL)
    }
    
    private func decodeJSONFile(at url: URL) -> SixAxisDataForJSON? {
        do {
            let jsonData = try Data(contentsOf: url)
            let jsonDecoder = JSONDecoder()
            let decodeData = try jsonDecoder.decode(SixAxisDataForJSON.self, from: jsonData)
            return decodeData
        } catch {
            print("디코딩실패 \(error.localizedDescription)")
            return nil
        }
    }
}
