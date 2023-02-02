//
//  FileManagerRepository.swift
//  GyroData
//
//  Created by Ayaan, Wonbi on 2023/01/31.
//

protocol FileManagerRepository {
    func create(_ domain: Motion, completion: @escaping (Result<Void, Error>) -> Void)
    func read(with id: String) throws -> MotionDTO
    func delete(with id: String) throws
}
