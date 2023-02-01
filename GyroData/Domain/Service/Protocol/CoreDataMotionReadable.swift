//
//  CoreDataMotionReadable.swift
//  GyroData
//
//  Created by Ayaan, Wonbi on 2023/01/31.
//

protocol CoreDataMotionReadable {
    associatedtype Domain: Identifiable
    associatedtype T: CoreDataRepository
    
    var coreDataRepository: T { get }
    
    func read(from offset: Int) -> [Domain]?
}
