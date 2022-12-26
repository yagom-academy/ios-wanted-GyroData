//
//  CoreDataManager.swift
//  GyroData
//
//  Created by 오경식 on 2022/12/26.
//

import Foundation
import CoreData

final class CoreDataManager {
    private(set) var fetchedAnalysisValue: [GyroData] = []
    static let shared = CoreDataManager()
    private lazy var context = persistentContainer.viewContext

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "GyroData")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                print(error.localizedDescription)
            }
        }
        return container
    }()

    private init() {}
}
