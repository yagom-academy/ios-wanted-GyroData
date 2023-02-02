//  GyroData - MeasureListViewModel.swift
//  Created by zhilly, woong on 2023/02/03

import Foundation

class MeasureListViewModel {
    let model: Observable<[MotionData]> = Observable([])
    
    private let coreDataManager = CoreDataManager.shared
    
    init() {
        fetchToCoreData()
    }
    
    func fetchToCoreData() {
        var fetchedData: [MotionData]
        
        do {
            fetchedData = try coreDataManager.fetchObjects()
            fetchedData.forEach { item in
                self.model.value.append(item)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
