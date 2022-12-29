//
//  CoreDataStorage.swift
//  GyroData
//
//  Created by 천수현 on 2022/12/28.
//

import CoreData

final class CoreDataStorage {

    static let shared = CoreDataStorage()

    private init() {}

    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MotionData")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                // TODO: - Log to Crashlytics
                assertionFailure("MotionData Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        persistentContainer.performBackgroundTask(block)
    }
}
