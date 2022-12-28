//
//  CoreDataManager.swift
//  GyroData
//
//  Created by minsson on 2022/12/27.
//

import CoreData

protocol LocalDatabase {
    var fileManager: CoreDataManagerDelegate? { get set }
    func create(data: MeasuredData)
    func read() -> [MeasuredData]
    func delete(data: MeasuredData)
}

final class CoreDataManager: LocalDatabase {
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MotionData")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    weak var fileManager: CoreDataManagerDelegate?
    
    func create(data: MeasuredData) {
        let context = persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "MotionData", in: context)
        if let entity = entity {
            let object = NSManagedObject(entity: entity, insertInto: context)
            object.setValue(data.uuid, forKey: "uuid")
            object.setValue(data.date, forKey: "date")
            object.setValue(data.measuredTime, forKey: "measuredTime")
            object.setValue(data.sensor.rawValue, forKey: "sensor")
        }
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
        
        fileManager?.create(data: data.sensorData, uuid: data.uuid)
    }
    
    func read() -> [MeasuredData] {
        let context = persistentContainer.viewContext
        do {
            let motionDataList = try context.fetch(MotionData.fetchRequest()) as! [MotionData]
            let measuredDataList = motionDataList.map { motionData in
                let sensorData = fileManager?.read(uuid: motionData.uuid)
                return MeasuredData(
                    uuid: motionData.uuid,
                    date: motionData.date,
                    measuredTime: motionData.measuredTime,
                    sensor: .init(rawValue: motionData.sensor)!,
                    sensorData: sensorData!
                )
            }
            return measuredDataList
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func delete(data: MeasuredData) {
        let context = persistentContainer.viewContext
        guard let motionData = retrieveManagedObejct(from: data) else { return }
        context.delete(motionData)
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
        fileManager?.delete(uuid: data.uuid)
    }
    
    private func retrieveManagedObejct(from data: MeasuredData) -> MotionData? {
        let context = persistentContainer.viewContext
        let request: NSFetchRequest<MotionData> = MotionData.fetchRequest()
        let predicate = NSPredicate(format: "uuid == %@", data.uuid as CVarArg)
        request.predicate = predicate
        do {
            let result = try context.fetch(request)
            return result[0]
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
