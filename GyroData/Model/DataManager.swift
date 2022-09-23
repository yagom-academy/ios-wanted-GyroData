//
//  DataManager.swift
//  GyroData
//
//  Created by 1 on 2022/09/20.
//
import UIKit
import Foundation
import CoreData

class DataManager {
    static var shared: DataManager = DataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: {
            (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var context: NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }
    
//    var container: NSPersistentContainer?
    
   
    
    var runkEntity: NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: "Run", in: context)
    }
    //Context 저장
    func saveToContext() {
        do {
            try context.save()

        } catch {
            print(error.localizedDescription)
        }
    }
    //Read 구현
    func fetchRun() -> [Run] {
        do {
            let request = Run.fetchRequest()
            let results = try context.fetch(request)
            return results
        } catch {
            print(error.localizedDescription)
        }
        return []
    }
    //Context 저장
    func insertRun(_ notice: RunDataList) {
        if let entity = runkEntity {
            let managedObject = NSManagedObject(entity: entity, insertInto: context)
            managedObject.setValue(notice.interval, forKey: "interval")
            managedObject.setValue(notice.timestamp, forKey: "timestamp")
            managedObject.setValue(notice.type, forKey: "gyro")
            saveToContext()
        }
    }
    //Read 구현
    func getRun() -> [RunDataList] {
        var notices: [RunDataList] = []
        let fetchResults = fetchRun()
        for result in fetchResults {
            let notice = RunDataList(timestamp: result.timestamp ?? "", type: result.gyro ?? "", interval: 0.0)
            notices.append(notice)
        }
        return notices
    }
    //update 구현
    func updateRun(_ notice: RunDataList) {
        let fetchResults = fetchRun()
        for result in fetchResults {
            if result.gyro == notice.type {
                result.timestamp = "업그레이드"
            }
        }
        saveToContext()
    }
    //Delete 구현
    func deleteRun(_ notice: RunDataList) {
        let fetchResults = fetchRun()
        let notice = fetchResults.filter({ $0.gyro == notice.type })[0]
        context.delete(notice)
        saveToContext()
    }
    
    //Delete 구현
    func deleteAllRun() {
        let fetchResults = fetchRun()
        for result in fetchResults {
            context.delete(result)
        }
        saveToContext()
    }
}
