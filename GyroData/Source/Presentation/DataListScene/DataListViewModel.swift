//
//  DataListViewModel.swift
//  GyroData
//
//  Created by Kyo, JPush on 2023/01/31.
//

import Foundation

final class DataListViewModel {
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
}
