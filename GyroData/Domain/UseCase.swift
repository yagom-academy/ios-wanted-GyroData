//
//  UseCase.swift
//  GyroData
//
//  Created by TORI on 2022/12/27.
//

import Foundation

final class UseCase {
    
    let repository = DataStore()
    
    func createItem(_ item: MeasureItem) {
        repository.createGyro(item: item)
    }
    
    func readItem(completion: @escaping (Result<[MeasureItem], Error>) -> ()) {
        repository.readGyro { [weak self] result in
            switch result {
            case let .success(entities):
                guard let items = self?.convertItems(entities) else { return }
                completion(.success(items))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    func deleteItem() {
        
    }
    
    private func convertItems(_ items: [ModelEntity]) -> [MeasureItem] {
        return items.map {
            MeasureItem(sensorType: $0.sensorType,
                     figure: $0.figure,
                     date: $0.date)
        }
    }
}
