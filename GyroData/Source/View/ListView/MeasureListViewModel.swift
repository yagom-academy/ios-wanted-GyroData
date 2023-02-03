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
            self.model.value = fetchedData
        } catch {
            print(error.localizedDescription)
        }
    }
}
