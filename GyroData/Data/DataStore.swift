//
//  DataStore.swift
//  GyroData
//
//  Created by TORI on 2022/12/26.
//

import UIKit
import CoreData

final class DataStore {
    
    private let appDelegate = UIApplication.shared.delegate as? AppDelegate
    private lazy var context: NSManagedObjectContext? = appDelegate?.persistentContainer.viewContext
    
    func createGyro(item: MeasureItem) {
        guard let context = context,
        let entity = NSEntityDescription.entity(forEntityName: String(describing: ModelEntity.self), in: context) else { return }
        
        let gyroData = ModelEntity(entity: entity, insertInto: context)
        gyroData.date = item.date
        gyroData.figure = item.figure
        gyroData.sensorType = item.sensorType
        changedContextValidate()
    }
    
    
    func readGyro(completion: @escaping (Result<[ModelEntity], Error>) -> () ) {
        guard let context = context else { return }
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: ModelEntity.self))
        
        do {
            guard let gyroData = try context.fetch(request) as? [ModelEntity] else { return }
            completion(.success(gyroData))
        } catch {
            completion(.failure(NSError()))
            print("데이터 가져오기 실패")
        }
    }
    
    func deleteGyro() {}
    
    // 코어데이터 내용이 변경되었을때만 저장
    private func changedContextValidate() {
        guard let context = context else { return }
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            print("컨텍스트 반영 실패")
        }
    }
}
