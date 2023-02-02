//
//  CoreDataMotionReadable.swift
//  GyroData
//
//  Created by Ayaan, Wonbi on 2023/01/31.
//

protocol CoreDataMotionReadable {
    var coreDataRepository: CoreDataRepository { get }
    
    func read(from offset: Int) -> [Motion]?
    func count() -> Int?
}
