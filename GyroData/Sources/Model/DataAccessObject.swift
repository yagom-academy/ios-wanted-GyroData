//
//  DataAccessObject.swift
//  GyroData
//
//  Created by kokkilE on 2023/06/15.
//

import Foundation

protocol DataAccessObject: Identifiable {
    associatedtype DataTransferObject
    
    var identifier: UUID? { get }
    
    func setValues(from model: DataTransferObject)
}
