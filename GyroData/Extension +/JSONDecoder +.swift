//
//  JSONDecoder +.swift
//  GyroData
//
//  Created by 써니쿠키 on 2023/02/01.
//

import Foundation

extension JSONDecoder {
    
    static func decode<T: Decodable>(_ type: T.Type, from jsonString: String) -> T? {
        let decoder: JSONDecoder = JSONDecoder()
        guard let data: Data = jsonString.data(using: .utf8) else {
            return nil
        }
        
        do {
            return try decoder.decode(type, from: data)
        } catch let DecodingError.dataCorrupted(context) {
            print(context)
            return nil
        } catch let DecodingError.keyNotFound(key, context) {
            print("Key \(key) not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
            return nil
        } catch let DecodingError.valueNotFound(value, context) {
            print("Value \(value) not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
            return nil
        } catch let DecodingError.typeMismatch(type, context) {
            print("Type \(type) mismatch:", context.debugDescription)
            print("codingPath:", context.codingPath)
            return nil
        } catch {
            print("error: ", error)
            return nil
        }
    }
}
