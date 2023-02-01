//
//  FileManager.swift
//  GyroData
//
//  Created by 로빈 on 2023/02/01.
//

import Foundation

class SensorFileManager: DataHandleable {
    typealias DataType = Measurement

    private let fileManager: FileManager
    private lazy var documentURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]

    init(fileManager: FileManager = FileManager.default) {
        self.fileManager = fileManager
    }

    func saveData(_ data: Measurement) throws {
        let encodedData = try JSONEncoder().encode(data)
        let fileName = "\(data.sensor.name+data.date.description).json"
        let fileURL = documentURL.appendingPathComponent(fileName)

        try encodedData.write(to: fileURL, options: [.atomicWrite])
    }

    func fetchData() -> Result<[Measurement], DataHandleError> {
        do {
            var fetchedData: [Measurement] = []
            let contents = try fileManager.contentsOfDirectory(at: documentURL, includingPropertiesForKeys: nil, options: [])

            for url in contents {
                let data = try Data(contentsOf: url)
                let measurement = try JSONDecoder().decode(Measurement.self, from: data)
                fetchedData.append(measurement)
            }
            
            return .success(fetchedData)
        } catch let error {
            return .failure(.fetchFailError(error: error))
        }
    }

    func deleteData(_ data: Measurement) throws {
        let fileName = "\(data.sensor.name+data.date.description).json"
        let fileURL = documentURL.appendingPathComponent(fileName)

        try fileManager.removeItem(at: fileURL)
    }
}
