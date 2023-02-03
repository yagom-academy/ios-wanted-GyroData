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
    private weak var alertDelegate: AlertPresentable?
    
    private var measureDatas:[MeasureData] = [] {
        didSet {
            delegate?.setupData(measureDatas)
        }
    }
    
    init(delegate: DataListConfigurable, alertDelegate: AlertPresentable) {
        self.delegate = delegate
        self.alertDelegate = alertDelegate
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
        transactionSevice.delete(date: measureDatas[index].date) { [weak self] result in
            switch result {
            case .success(_):
                return
            case .failure(let error):
                if let coreDataError = error as? CoreDataError {
                    self?.alertDelegate?.presentErrorAlert(message: coreDataError.errorDescription ?? "")
                    return
                } else if let fileError = error as? FileSystemError {
                    self?.alertDelegate?.presentErrorAlert(message: fileError.errorDescription ?? "")
                    return
                }
                self?.alertDelegate?.presentErrorAlert(message: error.localizedDescription)
            }
        }
    }
}
