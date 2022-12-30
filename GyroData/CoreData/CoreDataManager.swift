//
//  CoreDataManager.swift
//  GyroData
//
//  Created by unchain, Ellen J, yeton on 2022/12/26.
//

import Foundation
import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    
    private(set) var fetchedAnalysisValue: [GyroData] = []
    lazy var context = persistentContainer.viewContext
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
    
    func create(model: [CellModel], fileModel: [GraphModel]) {
        let content = GyroData(context: context)
        
        model.forEach {
            content.setValue($0.id, forKey: "id")
            content.setValue($0.analysisType, forKey: "analysisType")
            content.setValue($0.savedAt, forKey: "savedAt")
            content.setValue($0.measurementTime, forKey: "measurementTime")
        }
        
        GraphFileManager.shared.saveJsonData(data: fileModel, fileName: content.id ?? UUID())
        saveContext()
    }
    
    func read() -> [GyroData]? {
        do {
            fetchedAnalysisValue = try context.fetch(GyroData.fetchRequest()).reversed()
            return fetchedAnalysisValue
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }

    func delete(data: GyroData) {
        context.delete(data)
        
        saveContext()
    }
    
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
