//
//  CoreDataManager+DataHandleable.swift
//  GyroData
//
//  Created by 써니쿠키 on 2023/02/01.
//

import Foundation
import CoreData

struct CoreDataManager: DataHandleable {
    
    typealias DataType = Measurement
    
    private let persistentContainer: NSPersistentContainer = {
        let persistentContainer = NSPersistentContainer(name: "GyroCoreData")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error as? NSError {
                fatalError("unresolved Error \(error), \(error.userInfo)")
            }
        }
        
        return persistentContainer
    }()
    
    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveData(_ data: DataType) throws {
        let measurementCoreModel = MeasurementCoreModel(context: context)
        
        guard let axisValue = JSONEncoder.encode(data.axisValues) else {
            throw DataHandleError.encodingError
        }
        
        measurementCoreModel.sensor = Int16(data.sensor.rawValue)
        measurementCoreModel.date = data.date
        measurementCoreModel.time = data.time
        measurementCoreModel.axisValues = axisValue
        
        try context.save()
    }
    
    func fetchData() -> Result<[Measurement], DataHandleError> {
        let request = NSFetchRequest<MeasurementCoreModel>(entityName: "MeasurementCoreModel")
        var measurements: [Measurement] = []
        
        do {
            let fetchedData = try context.fetch(request)
            
            try fetchedData.forEach { measurementsCoreModel in
                let measurement = try convertTypeToMeasurement(from: measurementsCoreModel)
                measurements.append(measurement)
            }
            
            return .success(measurements)
        } catch {
            return .failure(DataHandleError.fetchFailError(error: error))
        }
    }
    
    func deleteData(_ data: DataType) throws {
        let request = NSFetchRequest<MeasurementCoreModel>(entityName: "MeasurementCoreModel")
        request.predicate = NSPredicate(format: "date = %@", data.date as NSDate)
        
        do {
            guard let measurementWillDelete = try context.fetch(request).first else {
                throw DataHandleError.noDataError(detail: "no fetched data for delete")
            }
            
            context.delete(measurementWillDelete)
            try context.save()
        }
    }
    
    private func convertTypeToMeasurement(from measurementCoreModel: MeasurementCoreModel) throws
    -> Measurement {
        let date = measurementCoreModel.date
        let time = measurementCoreModel.time
        let axisValues = measurementCoreModel.axisValues
        
        guard let sensor = Sensor(rawValue: Int(measurementCoreModel.sensor)) else {
            throw DataHandleError.noDataError(detail: "Sensor rawValue is Wrong")
        }
        
        guard let decodedAxisValues = JSONDecoder.decode([AxisValue].self, from: axisValues) else {
            throw DataHandleError.decodingError
        }
        
        return  Measurement(sensor: sensor, date: date, time: time, axisValues: decodedAxisValues)
    }
}
