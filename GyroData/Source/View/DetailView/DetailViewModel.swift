//  GyroData - DetailViewModel.swift
//  Created by zhilly, woong on 2023/02/04

import Foundation

class DetailViewModel {
    let model: Observable<FileManagedData> = .init(FileManagedData(createdAt: Date(),
                                                                   runtime: 0.0,
                                                                   sensorData: .init(x: [],
                                                                                     y: [],
                                                                                     z: [])))
    init(date: Date) {
        guard let data = fetch(createdAt: date) else { return }
        self.model.value = data
    }
    
    func fetch(createdAt: Date) -> FileManagedData? {
        guard let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory,
                                                             .userDomainMask,
                                                             true).first else { return nil }
        var filePath = URL(fileURLWithPath: path)
        let convertedDate = DateFormatter.convertToFileFormat(date: createdAt)
        let appendPathJsonComponent = convertedDate + ".json"
        filePath.appendPathComponent(appendPathJsonComponent)
        
        if let data = try? Data(contentsOf: filePath) {
            if let dataToJson = try? JSONDecoder().decode(FileManagedData.self, from: data) {
                return dataToJson
            }
        }
        return nil
    }
    
    
    
    
}
