//
//  JSONDataManager.swift
//  GyroData
//
//  Created by Aaron, Gundy on 2023/01/31.
//

import Foundation

final class JSONDataManager {

    let encoder = JSONEncoder()
    let decoder = JSONDecoder()

    var jsonString: String?

    func encode(domainData: Encodable) -> Data? {
        let jsonData = try? encoder.encode(domainData)

        return jsonData
    }

    func decode<T: Decodable>(type: T.Type, data: Data) -> T? {
        let decodedData = try? decoder.decode(type.self, from: data)

        return decodedData
    }

    func createJSONData(domainData: Encodable) {
        guard let data = encode(domainData: domainData) else {
            return
        }

        jsonString = String(data: data, encoding: .utf8)
    }
}


