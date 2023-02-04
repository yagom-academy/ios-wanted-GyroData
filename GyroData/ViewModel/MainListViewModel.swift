//
//  MainListViewModel.swift
//  GyroData
//
//  Created by leewonseok on 2023/02/03.
//

import Foundation

final class MainListViewModel{
    var motionDataList: [MotionEntity] = [] {
        didSet {
            tableViewHandler?()
        }
    }
    private var hasNextPage = false
    
    private var tableViewHandler: (() -> Void)?
    
    func bindTableView(handler: @escaping (() -> Void)) {
        tableViewHandler = handler
    }
    
    func fetchData() {
        guard let hasList = CoreDataManager.shared.fetchData(entity: MotionEntity.self, pageCount: 10, offset: motionDataList.count) else { return }
        
        if hasList.count == 0 {
            self.hasNextPage = false
        } else {
            self.hasNextPage = true
        }
        
        motionDataList.append(contentsOf: hasList)
    }
    
    func deleteData(dataIndex: Int) {
        CoreDataManager.shared.delete(entity: motionDataList[dataIndex])
        motionDataList.remove(at: dataIndex)
    }
    
    func clearData() {
        motionDataList = []
    }
    
    func paing() {
        if hasNextPage {
            fetchData()
        }
    }
}
