//
//  DataManager.swift
//  GyroData
//
//  Created by 1 on 2022/09/20.
//

import Foundation
import CoreData
class  DataManager {
    static let shared = DataManager()
    
    private init() {}
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    var runList = [Run]()
    
    func fetchRun() {
        let request: NSFetchRequest<Run> = Run.fetchRequest()
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Run")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: (error)")
            }
        }
        return container
    }()
    
    func saveContext(backgroundContext: NSManagedObjectContext? = nil) {
        let context = backgroundContext ?? viewContext
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch let error as NSError {
            print("Error: (error), (error.userInfo)")
        }
    }
}


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
