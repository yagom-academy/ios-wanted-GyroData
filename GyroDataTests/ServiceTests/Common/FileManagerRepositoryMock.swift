//
//  FileManagerRepositoryMock.swift
//  GyroDataTests
//
//  Created by Ayaan, Wonbi on 2023/02/01.
//

@testable import GyroData

final class FileManagerRepositoryMock: FileManagerRepository {
    typealias Domain = GyroData.Motion
    typealias Entity = GyroData.MotionDTO
    
    var isCalledCreateFunction: Bool = false
    var isCalledReadFunction: Bool = false
    var isCalledDeleteFunction: Bool = false
    let returnValueOfReadFunction: GyroData.MotionDTO = .init(
        id: .init(),
        date: .init(),
        type: .init(),
        time: .init(),
        x: [],
        y: [],
        z: []
    )
    
    func create(_ domain: GyroData.Motion, completion: @escaping (Result<Void, Error>) -> Void) {
        isCalledCreateFunction = true
        completion(.success(()))
    }
    
    func read(with id: String) throws -> GyroData.MotionDTO {
        isCalledReadFunction = true
        return returnValueOfReadFunction
    }
    
    func delete(with id: String) throws {
        isCalledDeleteFunction = true
    }
}
