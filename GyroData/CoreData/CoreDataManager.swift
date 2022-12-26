//
//  CoreDataManager.swift
//  GyroData
//
//  Created by unchain, Ellen J, yeton on 2022/12/26.
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
    
    func create(model: [AnalysisType]) {
        let content = GyroData(context: context)
        model.forEach {
            content.setValue($0.x, forKey: "x")
            content.setValue($0.y, forKey: "y")
            content.setValue($0.z, forKey: "z")
            content.setValue($0.measurementTime, forKey: "measurementTime")
            content.setValue($0.savedAt, forKey: "savedAt")
        }
        
        saveContext()
    }

    private func read() {
        do {
            fetchedAnalysisValue = try context.fetch(GyroData.fetchRequest())
        } catch {
            print(error.localizedDescription)
        }
    }

    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
                read()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
