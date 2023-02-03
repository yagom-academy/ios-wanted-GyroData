//
//  DataListViewModel.swift
//  GyroData
//
//  Created by Kyo, JPush on 2023/01/31.
//

import Foundation

final class DataListViewModel {
    enum Action {
        case cellSelect(index: Int)
        case measure
        case play(index: Int)
        case delete(index: Int)
    }
    
    private let transactionSevice = TransactionService(
        coreDataManager: CoreDataManager(),
        fileManager: FileSystemManager()
    )
    
    private weak var delegate: DataListConfigurable?
    
    private var measureDatas:[MeasureData] = [] {
        didSet {
            delegate?.setupData(measureDatas)
        }
    }
    
    init(delegate: DataListConfigurable) {
        self.delegate = delegate
        setupData()
    }
}

// MARK: - Bind With TransactionService
extension DataListViewModel {
    func setupData() {
        transactionSevice.bindData { [weak self] datas in
            self?.measureDatas = datas
        }
    }
    
    func action(_ action: Action) {
        switch action {
        case .cellSelect(let index):
            delegate?.setupSelectData(measureDatas[index])
        case .measure:
            delegate?.setupMeasure(transactionSevice)
        case .play(let index):
            delegate?.setupPlay(measureDatas[index])
        case .delete(let index):
            deleteData(index: index)
        }
    }
    
    private func deleteData(index: Int) {
        transactionSevice.delete(date: measureDatas[index].date) { result in
            switch result {
            case .success(_):
                return
            case .failure(let error):
                //TODO: Alert Delegate
                print(error)
            }
        }
    }
}
