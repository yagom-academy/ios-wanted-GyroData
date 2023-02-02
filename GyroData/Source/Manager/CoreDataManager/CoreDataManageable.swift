//  GyroData - CoreDataManageable.swift
//  Created by zhilly, woong on 2023/02/03

import Foundation
import CoreData

protocol CoreDataManageable {
    associatedtype Object: ManagedObjectModel
    
    func add(_ object: Object) throws
    func fetchObjects() throws -> [Object]
    func update(_ object: Object) throws
    func remove(_ object: Object) throws
}
