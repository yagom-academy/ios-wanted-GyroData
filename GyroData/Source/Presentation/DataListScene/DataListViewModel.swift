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
        case play
        case delete
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
            delegate?.setupMeasure()
        case .play:
            delegate?.setupPlay()
        case .delete:
            delegate?.setupDelete()
        }
    }
}
