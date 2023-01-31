//
//  CoreDataRepository.swift
//  GyroData
//
//  Created by Ayaan, Wonbi on 2023/01/31.
//

protocol CoreDataRepository {
    associatedtype Domain: Identifiable
    associatedtype Entity: Identifiable
    
    func create(_ entity: Entity) throws
    func read(from offset: Int) throws -> [Entity]
    func delete(_ id: String) throws
}
