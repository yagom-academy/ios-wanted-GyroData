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

    func saveJSON(data: MotionInfo) {
        let jsonEncoder = JSONEncoder()

        do {
            let encodedData = try jsonEncoder.encode(data)

            let fileURL = documentUrl.appending(path: data.date + ".json")

            do {
                try encodedData.write(to: fileURL)
            } catch {
                print(error)
            }
        } catch {
            print(error)
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
