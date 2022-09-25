//
//  Repository.swift
//  GyroData
//
//  Created by pablo.jee on 2022/09/20.
//

import Foundation
import CoreData

//UnitTest시 Repository 실제 클래스를 사용하면 안될것 같으므로(MockRepository를 만들어서 유닛테스트를 돌려야 하므로) 프로토콜을 추가함
protocol RepositoryProtocol: CoreDataRepositoryProtocol { }

// CoreData 와 통신하는 repository 가 들고 있는 프로토콜
protocol CoreDataRepositoryProtocol {
    func fetchFromCoreData(completion: @escaping ([MotionTask]) -> Void)
    func insertToCoreData(motion: MotionTask) -> Result<Bool, Error>
    func delete(motion: Motion) -> Result<Bool, Error>
}

protocol FileManagerRepositoryProtocol {
    func fetchFromFileManager(completion: @escaping ([MotionFile]) -> Void)
    func saveToFileManager(file: MotionFile)
}

//이 클래스가 들고 있는 어떠한 클래스가 자이로 데이터를 계산, 갱신 하게 하고
//이 클래스가 들고 있는 또다른 클래스가 코어데이터에 데이터 set, get 하게 하고 JSON 관련 처리를 하게 하면 되지 않을까 함
class Repository: RepositoryProtocol {
    
    private let coreDataRequest: NSFetchRequest<Motion> = Motion.fetchRequest()
    
    init() {
        
    }
}

extension Repository: CoreDataRepositoryProtocol {
    func fetchFromCoreData(completion: @escaping ([MotionTask]) -> Void) {
        var motionTasks: [MotionTask] = []
        let fetchResult = CoreDataManager.shared.fetchMotionTasks()
        
        switch fetchResult {
        case .success(let motions):
            motions.forEach { motionTasks.append(MotionTask(type: $0.type ?? "", time: $0.time , date: $0.date ?? Date(), path: $0.path ?? "")) }
            DispatchQueue.main.async {
                completion(motionTasks)
            }
        
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
    
    func insertToCoreData(motion: MotionTask) -> Result<Bool, Error> {
        return CoreDataManager.shared.insertMotionTask(motion: motion)
    }
    
    func delete(motion: Motion) -> Result<Bool, Error> {
        return CoreDataManager.shared.delete(object: motion)
    }
}
