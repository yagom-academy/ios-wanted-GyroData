//
//  JSONEncoder +.swift
//  GyroData
//
//  Created by 써니쿠키 on 2023/02/01.
//

import Foundation

extension JSONEncoder {
    
    static func encode<T: Encodable>(_ value: T) -> String? {
        let encoder: JSONEncoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        do {
            let data = try encoder.encode(value)
            return String(data: data, encoding: .utf8)
        } catch let EncodingError.invalidValue(value, context) {
            print("Value \(value) not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
            return nil
        } catch {
            print("error: ", error)
            return nil
        }
    }
}
