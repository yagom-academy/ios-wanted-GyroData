//
//  CoreDataRepository.swift
//  GyroData
//
//  Created by Ayaan, Wonbi on 2023/01/31.
//

protocol CoreDataRepository {
    associatedtype Domain: Identifiable
    associatedtype Entity: Identifiable
    
    func create(_ domain: Domain, completion: @escaping (Result<Entity, Error>) -> Void)
    func read(from offset: Int) throws -> [Entity]
    func delete(with id: String) throws
}
