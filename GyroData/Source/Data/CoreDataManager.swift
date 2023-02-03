//
//  CoreDataManager.swift
//  GyroData
//
//  Created by Kyo, JPush on 2023/01/30.
//

import CoreData
import Foundation

final class CoreDataManager {
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SensorData")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                print(error.localizedDescription)
            }
        }
        return container
    }()
    private lazy var context = persistentContainer.viewContext
    
    private func translateModel(from entity: SensorData) -> MeasureData {
        let model = MeasureData(
            xValue: entity.xValue,
            yValue: entity.yValue,
            zValue: entity.zValue,
            runTime: entity.runTime,
            date: entity.date,
            type: Sensor(rawValue: Int(entity.type))
        )
        
        return model
    }
}

extension CoreDataManager: DataManageable {
    func save(_ model: MeasureData) throws {
        guard let type = model.type?.rawValue,
              let entity = NSEntityDescription.entity(forEntityName: "SensorData", in: context) else {
            throw CoreDataError.invalidData
        }
        
        let content = NSManagedObject(entity: entity, insertInto: context)
        
        content.setValue(model.xValue, forKey: "xValue")
        content.setValue(model.yValue, forKey: "yValue")
        content.setValue(model.zValue, forKey: "zValue")
        content.setValue(model.date, forKey: "date")
        content.setValue(model.runTime, forKey: "runTime")
        content.setValue(Double(type), forKey: "type")
        
        do {
            try context.save()
        } catch {
            throw error
        }
    }

    func fetch(offset: Int, limit: Int) throws -> [MeasureData]  {
        let request = SensorData.fetchRequest()
        
        request.fetchOffset = offset
        request.fetchLimit = limit
        
        do {
            let result = try context.fetch(request)
            let models = result.map(translateModel)
            return models
        } catch {
            throw error
        }
    }
    
    func delete(_ date: Date) throws {
        let request = SensorData.fetchRequest()
        
        request.predicate = NSPredicate(format: "date == %@", date as CVarArg)
        
        do {
            let result = try context.fetch(request)
            guard let firstData = result.first else {
                throw CoreDataError.invalidData
            }
            
            context.delete(firstData)
            try context.save()
        } catch {
            throw error
        }
    }
}
