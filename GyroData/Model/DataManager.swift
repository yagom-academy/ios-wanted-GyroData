//
//  DataManager.swift
//  GyroExample
//
//  Created by KangMingyo on 2022/09/24.
//

import Foundation
import CoreData

class DataManager {
    
    static let shared = DataManager()
    private init() {
    }
    
    var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    var saveList = [Save]()
    //데이터 저장
    func fetchSave() {
        let request: NSFetchRequest<Save> = Save.fetchRequest()
        //코어데이터 겟 데이타 리미트 리퀘스트 10개 request.fetchOffset = 0; request.fetchLimit = 10;
        //데이터 불러오기 10개씩 일단 3개로
        request.fetchLimit = 3 // 0123 // 4567 // 891011
        request.fetchOffset = saveList.count  // 카운터
        let sortByDateDesc = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [sortByDateDesc]
        
        do {
            saveList.append(contentsOf: try mainContext.fetch(request))  //니가 정해줘서 가능해
            
        } catch {
            print(error)
        }
    }
    
    //부분Delete 구현
    func deleteRun(object: Save) -> Bool {
        self.mainContext.delete(object)
        self.saveMainContext()
        do {
            try mainContext.save()
            return true
        } catch {
            return false
        }
    }
    func saveMainContext() {
        mainContext.perform {
            if self.mainContext.hasChanges {
                do {
                    try self.mainContext.save()
                } catch {
                    print(error)
                }
            }
        }
    }
    func addNewSave(_ name: String?, _ time: Float?, _ xData: [Float], yData: [Float], zData: [Float]) {
        let newSave = Save(context: mainContext)
        newSave.name = name
        newSave.date = Date()
        newSave.time = time ?? 0.00
        newSave.xData = xData as NSObject
        newSave.yData = yData as NSObject
        newSave.zData = zData as NSObject
        saveContext()
    }
    
    func deleteReview(_ save: Save?) {
        if let save = save {
            mainContext.delete(save)
            saveContext()
        }
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "GyroExample")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

