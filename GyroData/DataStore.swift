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
    
    func createGyro(item: GyroItem) {
        guard let context = context,
        let entity = NSEntityDescription.entity(forEntityName: String(describing: ModelEntity.self), in: context) else { return }
        
        let gyroData = ModelEntity(entity: entity, insertInto: context)
        gyroData.date = item.date
        gyroData.figure = item.figure
        gyroData.sensorType = item.sensorType
        changedContextValidate()
    }
    
    
    func readGyro(completion: @escaping () -> () ) {}
    
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
