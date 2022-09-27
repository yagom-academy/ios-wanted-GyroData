//
//  CoreDataManager.swift
//  GyroData
//
//  Created by 김지인 on 2022/09/24.
//

import CoreData
import UIKit

class CoreDataManager {
    var datasoooooo = [GyroModel]()
    static var shared: CoreDataManager = CoreDataManager()
    
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let request: NSFetchRequest<GyroModel> = GyroModel.fetchRequest()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "GyroModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    var context: NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }
    
    var entityName: NSEntityDescription? {
        return  NSEntityDescription.entity(forEntityName: "GyroModel", in: context)
    }
    
    func fetchTen(offset:Int) -> [GyroModel] {
        do {
            request.fetchLimit = 10
            request.fetchOffset = offset
            let fetchdata = try self.context.fetch(request)

            return fetchdata
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    @discardableResult
    func insertMeasure(measure: Measure) -> Bool {
        let entity = NSEntityDescription.entity(forEntityName: "GyroModel", in: self.context)
        
        if let entity = entity {
            let managedObject = NSManagedObject(entity: entity, insertInto: self.context)
            
            managedObject.setValue(measure.id, forKey: "id")
            managedObject.setValue(measure.title, forKey: "title")
            managedObject.setValue(measure.second, forKey: "second")
            managedObject.setValue(measure.measureDate, forKey: "measureDate")
            
            do {
                try self.context.save()
                return true
            } catch {
                print(error.localizedDescription)
                return false
            }
        } else {
            return false
        }
    }
    
    @discardableResult
    func delete(object: NSManagedObject) -> Bool {
        self.context.delete(object)
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
    
    @discardableResult
    func deleteAll() -> Bool {
        let request: NSFetchRequest<NSFetchRequestResult> = GyroModel.fetchRequest()
        let delete = NSBatchDeleteRequest(fetchRequest: request)
        do {
            try self.context.execute(delete)
            return true
        } catch {
            return false
        }
    }
    
    func count() -> Int? {
        do {
            let count = try self.context.count(for: request)
            return count
        } catch {
            return nil
        }
    }
}

//    func fetchSave() {
//        let request = NSFetchRequest<GyroModel>(entityName: "GyroModel")
//
//        var fetchOffset = 0
//        request.fetchOffset = fetchOffset
//        request.fetchLimit = 10
//        do{
//            var users: [GyroModel] = try! context.fetch(request)
//            print("🐤🐤🐤🐤🐤🐤🐤🐤\(users.count)")
//            while users.count > 0{
//                fetchOffset = fetchOffset + users.count
//                request.fetchOffset = fetchOffset
//                users = try! context.fetch(request)
//                print("🙈🙈🙈🙈🙈🙈🙈\(users.count)")
//            }
//        }

//func fetchTen(count:Int) -> [GyroModel] {
//        do {
//            var fetchOffset = 0
//            request.fetchLimit = 10
//            request.fetchOffset = count
//            fetchOffset = fetchOffset + request.fetchOffset
//            let fetchdata = try self.context.fetch(request)
////            print("🐤🐤🐤🐤🐤🐤🐤🐤\(fetchdata.count)")
//            return fetchdata
//        } catch {
//            print(error.localizedDescription)
//            return []
//        }
//    }
