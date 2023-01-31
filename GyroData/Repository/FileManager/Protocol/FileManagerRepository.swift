//
//  FileManagerRepository.swift
//  GyroData
//
//  Created by Ayaan, Wonbi on 2023/01/31.
//

protocol FileManagerRepository {
    associatedtype Domain: Identifiable
    associatedtype Entity: Identifiable
    
    func create(_ domain: Domain) throws
    func read(with id: String) throws -> Entity
    func delete(with id: String) throws
}
