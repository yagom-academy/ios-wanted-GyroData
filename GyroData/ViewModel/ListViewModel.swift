//
//  ListViewModel.swift
//  GyroData
//
//  Created by 이원빈 on 2022/12/26.
//

import Foundation

protocol ListViewModelInput {
    var models: Observable<[MeasuredData]> { get }
}

protocol ListViewModelOutput { }

protocol ListViewModel: ListViewModelInput, ListViewModelOutput { }

final class DefaultListViewModel: ListViewModel {
    private let coreDataManager = CoreDataManager()
    private let fileHandlerManager = FileHandleManager()
    
    var models: Observable<[MeasuredData]> = Observable([])
    
    init() {
        coreDataManager.fileManager = fileHandlerManager
    }
    
    func fetchData() {
        models.value = coreDataManager.read()
    }
    
    func deleteData(data: MeasuredData) {
        coreDataManager.delete(data: data)
        fetchData()
    }
}
