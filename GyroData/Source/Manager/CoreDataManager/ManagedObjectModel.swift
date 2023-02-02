//  GyroData - ManagedObjectModel.swift
//  Created by zhilly, woong on 2023/02/03

import CoreData.NSManagedObject

protocol ManagedObjectModel: Hashable {
    associatedtype Object: NSManagedObject
    var objectID: String? { get set }
    
    init?(from: Object)
}

extension ManagedObjectModel {
    public static func == (lhs: any ManagedObjectModel, rhs: any ManagedObjectModel) -> Bool {
        return lhs.objectID == rhs.objectID
    }
}
