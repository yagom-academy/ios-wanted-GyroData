//
//  UseCase.swift
//  GyroData
//
//  Created by TORI on 2022/12/27.
//

import Foundation

final class UseCase {
    
    let repository = DataStore()
    
    func createItem(_ item: GyroItem) {
        repository.createGyro(item: item)
    }
    
    func readItem(completion: @escaping ([GyroItem]) -> ()) {
        repository.readGyro { [weak self] entities in
            guard let items = self?.convertItems(entities) else { return }
            completion(items)
        }
    }
    
    func deleteItem() {
        
    }
    
    private func convertItems(_ items: [ModelEntity]) -> [GyroItem] {
        return items.map {
            GyroItem(sensorType: $0.sensorType,
                     figure: $0.figure,
                     date: $0.date)
        }
    }
}
