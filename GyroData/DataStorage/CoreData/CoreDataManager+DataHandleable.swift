//
//  CoreDataManager+DataHandleable.swift
//  GyroData
//
//  Created by 써니쿠키 on 2023/02/01.
//

import Foundation
import CoreData

final class CoreDataManager: MeasurementDataHandleable {

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
    
    private let fetchLimit = 10
    private var fetchOffset: Int = 0
    private lazy var increaseOffset = makeOffsetIncreaser(by: fetchLimit)
    
    func changeFetchOffset(isInitialFetch: Bool) {
        if isInitialFetch {
            increaseOffset = makeOffsetIncreaser(by: fetchLimit)
            fetchOffset = 0
        } else {
            fetchOffset = increaseOffset()
        }
    }
    
    func saveData(_ data: Measurement) throws {
        guard let axisValue = JSONEncoder.encode(data.axisValues) else {
            throw DataHandleError.encodingError
        }

        let measurementCoreModel = MeasurementCoreModel(context: context)
        measurementCoreModel.sensor = Int16(data.sensor.rawValue)
        measurementCoreModel.date = data.date
        measurementCoreModel.time = data.time
        measurementCoreModel.axisValues = axisValue
        
        try context.save()
    }
    
    func fetchData() throws -> [Measurement] {
        var measurements: [Measurement] = []
        let request = NSFetchRequest<MeasurementCoreModel>(entityName: "MeasurementCoreModel")
        request.fetchLimit = fetchLimit
        request.fetchOffset = fetchOffset
        
        let fetchedData = try context.fetch(request)
        
        try fetchedData.forEach { measurementsCoreModel in
            let measurement = try convertTypeToMeasurement(from: measurementsCoreModel)
            measurements.append(measurement)
        }
        
        return measurements
    }
    
    func deleteData(_ data: Measurement) throws {
        let request = NSFetchRequest<MeasurementCoreModel>(entityName: "MeasurementCoreModel")
        request.predicate = NSPredicate(format: "date = %@", data.date as NSDate)

        guard let measurementWillDelete = try context.fetch(request).first else {
            throw DataHandleError.noDataError(detail: "저장되어 있지 않은 데이터입니다.")
        }

        context.delete(measurementWillDelete)
        try context.save()
    }

    func deleteAll() throws {
        let request = NSFetchRequest<MeasurementCoreModel>(entityName: "MeasurementCoreModel")

        let measurementsWillDelete = try context.fetch(request)
        measurementsWillDelete.forEach { measurement in
            context.delete(measurement)
        }
    }
    
    private func convertTypeToMeasurement(from measurementCoreModel: MeasurementCoreModel) throws -> Measurement {
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
    
    private func makeOffsetIncreaser(by amount: Int) -> () -> Int {
        var offset = 0
        func increase() -> Int {
            offset += amount
            return offset
        }
        return increase
    }
}
