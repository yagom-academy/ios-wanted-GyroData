//
//  DataManager.swift
//  GyroExample
//
//  Created by KangMingyo on 2022/09/24.
//

import Foundation
import CoreData

class DataManager {
    //타입 프로퍼티
    static let shared = DataManager()
    private init() { }
    
    var isFetching: Bool = false
    //데이터를 저장할 배열선언후 초기화
    var saveList = [Save]()
    
    var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    //데이터 베이스에서 데이터를 읽어오고 리쿼스트 만들기
    func fetchSave() {
        if isFetching {
            print("isFetching...")
            return
        }
        isFetching = true
        let request: NSFetchRequest<Save> = Save.fetchRequest()
        request.fetchLimit = 10
        request.fetchOffset = saveList.count
        // 날짜 내림차순 sort
        let sortByDateDesc = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [sortByDateDesc]
        do {  //데이터 호출
            saveList.append(contentsOf: try mainContext.fetch(request))
            print("Fetched!")
            isFetching = false
        } catch {
            print(error)
            isFetching = false
        }
    }
    
    // 부분 Delete 구현
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
        saveContext()
    }
    func addNewSave(_ name: String?, _ time: Float?, _ xData: [Float], yData: [Float], zData: [Float]) {
        // 데이터베이스의 sav를 저장하는데 필요한 인스턴스 생성
        let newSave = Save(context: mainContext)
        //값 입력
        newSave.name = name
        newSave.date = Date()
        newSave.time = time ?? 0.00
        newSave.xData = xData as NSObject
        newSave.yData = yData as NSObject
        newSave.zData = zData as NSObject
        saveList.insert(newSave, at: 0)  // 데이터 생성시 업데이트
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

