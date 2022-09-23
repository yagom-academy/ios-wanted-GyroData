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

    func loadJSON(fileName: String) -> Data? {

        guard let documentUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }

        let url = URL(fileURLWithPath: fileName + ".json", relativeTo: documentUrl)

        do {
            let data:Data = try Data(contentsOf: url)

            return data

        } catch {
            print(error)
            print("\(fileName) 파일이 존재하지 않음")
            return nil
        }
    }

    func parseJSON(with JSONData: Data) -> MotionInfo? {
        let decoder = JSONDecoder()

        do {
            let decodedData = try decoder.decode(MotionInfo.self, from: JSONData)

            return decodedData
        } catch {
            print(error)
            return nil
        }
    }

    func getMotionInfo(name: String) -> MotionInfo? {
        guard let jsonFile = loadJSON(fileName: name), let motionInfo = parseJSON(with: jsonFile) else { return nil }

        return motionInfo
    }
}
