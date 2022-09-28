//
//  Repository.swift
//  GyroData
//
//  Created by pablo.jee on 2022/09/20.
//

import Foundation
import CoreData

//UnitTest시 Repository 실제 클래스를 사용하면 안될것 같으므로(MockRepository를 만들어서 유닛테스트를 돌려야 하므로) 프로토콜을 추가함
protocol RepositoryProtocol: CoreDataRepositoryProtocol, FileManagerRepositoryProtocol { }

// CoreData 와 통신하는 repository 가 들고 있는 프로토콜
protocol CoreDataRepositoryProtocol {
    func fetchFromCoreData() async throws -> [MotionTask]
    func insertToCoreData(motion: MotionTask) async throws
    func deleteFromCoreData(motion: MotionTask) async throws
}

protocol FileManagerRepositoryProtocol {
    func fetchFromFileManager(fileName name: String) async throws -> MotionFile
    func saveToFileManager(file: MotionFile) async throws
    func deleteFromFileManager(fileName name: String) async throws
}

//이 클래스가 들고 있는 어떠한 클래스가 자이로 데이터를 계산, 갱신 하게 하고
//이 클래스가 들고 있는 또다른 클래스가 코어데이터에 데이터 set, get 하게 하고 JSON 관련 처리를 하게 하면 되지 않을까 함
class Repository: RepositoryProtocol {
    
    private let coreDataRequest: NSFetchRequest<Motion> = Motion.fetchRequest()
    
    init() {
        
    }
}

extension Repository: CoreDataRepositoryProtocol {
    func fetchFromCoreData() async throws -> [MotionTask] {
        let fetchResult = try await CoreDataManager.shared.fetchMotionTasks()
        let result = fetchResult.map { motion in
            let task = MotionTask(type: motion.type ?? "", time: motion.time, date: motion.date ?? Date(), path: motion.path ?? "")
            return task
        }
        
        return result
    }
    
    func insertToCoreData(motion: MotionTask) async throws {
        _ = try await CoreDataManager.shared.insertMotionTask(motion: motion)
        return
    }
    
    func deleteFromCoreData(motion: MotionTask) async throws {
        _ = try await CoreDataManager.shared.deleteMotionTask(motion: motion)
        return
    }
}

extension Repository: FileManagerRepositoryProtocol {
    func fetchFromFileManager(fileName name: String) async throws -> MotionFile {
        let result = try await FileManager.default.loadMotionFile(name: name)
        return result
    }
    
    func saveToFileManager(file: MotionFile) async throws {
        _ = try await FileManager.default.saveMotionFile(file: file)
        return
    }
    
    func deleteFromFileManager(fileName name: String) async throws {
        _ = try await FileManager.default.removeMotionFile(name: name)
        return
    }
    
}
