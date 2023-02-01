//
//  CoreDataRepositoryMock.swift
//  GyroDataTests
//
//  Created by Ayaan, Wonbi on 2023/02/01.
//

@testable import GyroData

final class CoreDataRepositoryMock: CoreDataRepository {
    typealias Domain = GyroData.Motion
    typealias Entity = GyroData.MotionMO
    
    var isCalledCreateFunction: Bool = false
    var isCalledReadFunction: Bool = false
    var isCalledDeleteFunction: Bool = false
    let returnValuesOfReadFunction: [GyroData.MotionMO] = []
    
    func create(_ domain: GyroData.Motion, completion: @escaping (Result<Void, Error>) -> Void) {
        isCalledCreateFunction = true
        completion(.success(()))
    }
    
    func read(from offset: Int) throws -> [GyroData.MotionMO] {
        isCalledReadFunction = true
        return returnValuesOfReadFunction
    }
    
    func delete(with id: String) throws {
        isCalledDeleteFunction = true
    }
}
