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

    func fetch(offset: Int, limit: Int) -> Result<[MeasureData], Error> {
        let request = SensorData.fetchRequest()
        
        request.fetchOffset = offset
        request.fetchLimit = limit
        
        do {
            let result = try context.fetch(request)
            let models = result.map(translateModel)
            
            return .success(models)
        } catch {
            return .failure(error)
        }
    }
    
    func delete(_ model: MeasureData) -> Result<Void, Error> {
        let request = SensorData.fetchRequest()
        
        request.predicate = NSPredicate(format: "date == %@", model.date as CVarArg)
        
        do {
            let result = try context.fetch(request)
            guard let firstData = result.first else {
                return .failure(CoreDataError.invalidData)
            }
            
            context.delete(firstData)
            try context.save()
                
            return .success(())
        } catch {
            return .failure(error)
        }
    }
}

private extension CoreDataManager {
    func translateModel(from entity: SensorData) -> MeasureData {
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
