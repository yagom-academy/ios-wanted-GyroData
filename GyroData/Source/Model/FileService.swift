//
//  FileService.swift
//  GyroData
//
//  Created by Subin Kim on 2022/09/22.
//

import Foundation

class FileService {

    static let shared = FileService()

    let documentUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

    func saveJSON(data: MotionInfo) throws {
        let jsonEncoder = JSONEncoder()

        do {
            let encodedData = try jsonEncoder.encode(data)

            let fileURL = documentUrl.appending(path: data.date + ".json")

            do {
                try encodedData.write(to: fileURL)
            } catch {
                throw DataError.writeErr
            }
        } catch {
            throw DataError.encodedErr
        }
    }

    func deleteJSON(fileName: String) {
        let fileURL = documentUrl.appending(path: fileName + ".json")

        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch {
            print(error)
        }
    }
}
