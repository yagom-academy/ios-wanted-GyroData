//
//  DataHandleableProtocol.swift
//  GyroData
//
//  Created by 써니쿠키 on 2023/02/01.
//

import Foundation

protocol DataHandleable {
    
    associatedtype DataType
    
    func saveData(_ data: DataType) throws -> Void
    
    func fetchData() -> Result<[DataType], DataHandleError>
    
    func deleteData(_ data: DataType) throws -> Void
}

protocol MeasurementDataHandleable: DataHandleable  where DataType == Measurement {
    
}
