//
//  CoreDataManager.swift
//  GyroData
//
//  Created by Kyo, JPush on 2023/01/30.
//

import CoreData
import Foundation

class CoreDataManager {
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SensorData")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                print(error.localizedDescription)
            }
        }
        return container
    }()
    lazy var context = persistentContainer.viewContext
    
    func save(_ model: MeasureData) -> Result<Void, Error> {
        let content = SensorData(context: self.context)
        
        content.setValue(model.xValue, forKey: "xValue")
        content.setValue(model.yValue, forKey: "yValue")
        content.setValue(model.zValue, forKey: "zValue")
        content.setValue(model.date, forKey: "date")
        content.setValue(model.runTime, forKey: "runTime")
        content.setValue(model.type, forKey: "type")
        
        do {
            try context.save()
            return .success(())
        } catch {
            return .failure(error)
        }
    }
}
