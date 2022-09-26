//
//  JsonFetchManager.swift
//  GyroData
//
//  Created by 김지인 on 2022/09/26.
//

import Foundation

protocol JsonFetchProtocol {
    func request(id: String) -> Result<[GyroJson], Error>
}

enum JsonFetchError: Error {
    case notFound
}

class JsonFetchManager: JsonFetchProtocol {
    
    static let shared: JsonFetchManager = .init()
    
    func request(id: String) -> Result<[GyroJson], Error> {
        guard let path = Bundle.main.url(forResource: id, withExtension: "json") else { return .failure(JsonFetchError.notFound) }
        
        do {
            let data = try Data(contentsOf: path)
            let fetch = try JSONDecoder().decode([GyroJson].self, from: data)
            return .success(fetch)
        } catch let error {
            return .failure(error)
        }
    }
    
}
