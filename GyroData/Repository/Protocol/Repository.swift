//
//  Repository.swift
//  GyroData
//
//  Created by Ayaan, Wonbi on 2023/01/31.
//

protocol Repository {
    associatedtype Entity: Identifiable
    
    func create(_ entity: Entity) throws
    func read(from offset: Int) throws -> [Entity]
    func read(with id: String) throws -> Entity
    func delete(with id: String) throws -> Entity
}
