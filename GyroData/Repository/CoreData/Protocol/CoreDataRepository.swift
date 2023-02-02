//
//  CoreDataRepository.swift
//  GyroData
//
//  Created by Ayaan, Wonbi on 2023/01/31.
//

protocol CoreDataRepository {
    func create(_ domain: Motion, completion: @escaping (Result<Void, Error>) -> Void)
    func read(from offset: Int) throws -> [MotionMO]
    func count() throws -> Int
    func delete(with id: String) throws
}
