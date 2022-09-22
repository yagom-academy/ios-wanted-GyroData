//
//  DataManager.swift
//  GyroData
//
//  Created by 1 on 2022/09/20.
//

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
//            managedObject.setValue(notice.acc, forKey: "acc")
            managedObject.setValue(notice.gyro, forKey: "gyro")
//            managedObject.setValue(notice.uuid, forKey: "uuid")
            saveToContext()
        }
    }
    //Read 구현
    func getRun() -> [RunDataList] {
        var notices: [RunDataList] = []
        let fetchResults = fetchRun()
        for result in fetchResults {
//            let notice = RunDataList(uuid: 1, gyro: "gy", acc: "acc", timestamp: "ti", interval: 1.1)
            let notice = RunDataList(timestamp: result.timestamp ?? "", gyro: result.gyro ?? "", interval: 1.1)
            notices.append(notice)
        }
        return notices
    }
    //update 구현
    func updateRun(_ notice: RunDataList) {
        let fetchResults = fetchRun()
        for result in fetchResults {
            if result.gyro == notice.gyro {
                result.gyro = "업그레이드"
            }
        }
        saveToContext()
    }
    //Delete 구현
    func deleteRun(_ notice: RunDataList) {
        let fetchResults = fetchRun()
        let notice = fetchResults.filter({ $0.acc == notice.gyro }) [0]
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





//class  DataManager {  하기전 최신
//    static let shared = DataManager()
//
//    private init() {}
//
//    var viewContext: NSManagedObjectContext {
//        return persistentContainer.viewContext
//    }
//
//    var runList = [Run]()
//    let container = NSPersistentContainer(name: "Run")
//
//    func fetchRun() {
//        let request: NSFetchRequest<Run> = Run.fetchRequest()
//    }
//
//    lazy var persistentContainer: NSPersistentContainer = {
//        let container = NSPersistentContainer(name: "Run")
//        container.loadPersistentStores { description, error in
//            if let error = error {
//                fatalError("Unable to load persistent stores: (error)")
//            }
//        }
//        return container
//    }()
//
//    func saveContext(backgroundContext: NSManagedObjectContext? = nil) {
//        let context = backgroundContext ?? viewContext
//        guard context.hasChanges else { return }
//        do {
//            try context.save()
//        } catch let error as NSError {
//            print("Error: (error), (error.userInfo)")
//        }
//    }
//}


//    static let shared = DataManager()
//    var runList = [Run]()
//
//    func fetchRun() {
//        let request: NSFetchRequest<Run> = Run.fetchRequest()
//    }
//
//    lazy var persistentContainer: NSPersistentContainer = {
//        let container = NSPersistentContainer(name: "Run")
//        container.loadPersistentStores { description, error in
//            if let error = error as! NSError? {
//                fatalError("Unable to load persistent stores: (error)")
//            }
//        }
//        return container
//    }()
//    var context: NSManagedObjectContext {
//        return self.persistentContainer.viewContext
//    }



//    var viewContext: NSManagedObjectContext {
//        return persistentContainer.viewContext
//    }
//
//    var runList = [Run]()
//
//    func fetchRun() {
//        let request: NSFetchRequest<Run> = Run.fetchRequest()
//    }
//
//    lazy var persistentContainer: NSPersistentContainer = {
//        let container = NSPersistentContainer(name: "Run")
//        container.loadPersistentStores { description, error in
//            if let error = error {
//                fatalError("Unable to load persistent stores: (error)")
//            }
//        }
//        return container
//    }()
//
//    func saveContext() {
//        let context = persistentContainer.viewContext
//        if context.hasChanges {
//            do {
//                try context.save()
//            } catch let error as NSError {
//                print("Error: (error), (error.userInfo)")
//            }
//        }
//    }






//class DataManager {
//    static let shared = DataManager()
//    private init() {
//
//    }
//
//    var mainContenxt: NSManagedObjectContext {
//        return persistentContainer.viewContext
//    }
//
//    var testlist = [Run]()
//
//    func fetchMemo() {
//        let request: NSFetchRequest<Run> = Run.fetchRequest()
//                                                 //키값 확인하기
//        let sortByDateDesc = NSSortDescriptor(key: "insertDate", ascending: false)
//        request.sortDescriptors = [sortByDateDesc]
//
//        do {
//           testlist = try mainContenxt.fetch(request)
//        } catch {
//            print(error)
//        }
//    }
//
//
//    // MARK: - core Data stack
//    //    2-1. NSManagedObjectContext를 가져온다.
//    lazy var persistentContainer: NSPersistentContainer = {
//        let container = NSPersistentContainer(name: "Model")
//        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//            if let error = error as NSError? {
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
//        })
//        return container
//    }()
//
//    func saveContext () {
//        let context = persistentContainer.viewContext
//        if context.hasChanges {
//            do {
//                try context.save()
//            } catch {
//                let nserror = error as NSError
//                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//            }
//        }
//    }
//    //여기부분까지
//}
