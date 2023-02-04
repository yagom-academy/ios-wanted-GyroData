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
        case viewWillAppearEvent
        case scrollToBottomEvent
    }
    
    private let transactionSevice = TransactionService(
        coreDataManager: CoreDataManager(),
        fileManager: FileSystemManager()
    )
    
    weak var delegate: DataListConfigurable?
    weak var alertDelegate: AlertPresentable?
    
    private var measureDatas: [MeasureData] = [] {
        didSet {
            delegate?.setupData(measureDatas)
        }
    }
    
    private var page: Int {
        let offset = measureDatas.count / 10
        let page = (offset + 1) * 10
        
        return page
    }
    
    init() {
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
        case .viewWillAppearEvent:
            fetchData()
        case .scrollToBottomEvent:
            paginationData()
        }
    }
    
    private func deleteData(index: Int) {
        transactionSevice.delete(date: measureDatas[index].date) { [weak self] result in
            switch result {
            case .success(_):
                return
            case .failure(let error):
                if let coreDataError = error as? CoreDataError {
                    self?.alertDelegate?.presentErrorAlert(
                        title: "오류발생",
                        message: coreDataError.errorDescription ?? ""
                    )
                    return
                } else if let fileError = error as? FileSystemError {
                    self?.alertDelegate?.presentErrorAlert(
                        title: "오류발생",
                        message: fileError.errorDescription ?? ""
                    )
                    return
                }
                self?.alertDelegate?.presentErrorAlert(
                    title: "오류발생",
                    message: error.localizedDescription
                )
            }
        }
    }
    
    private func fetchData() {
        let result = transactionSevice.dataLoad(offset: 0, limit: page)
        
        switch result {
        case .success(let dataList):
            measureDatas = dataList
        case .failure(let failure):
            alertDelegate?.presentErrorAlert(
                title: "불러오기 실패",
                message: failure.localizedDescription
            )
        }
    }
    
    private func paginationData() {
        let result = transactionSevice.dataLoad(offset: 0, limit: page + 1)
        
        switch result {
        case .success(let dataList):
            measureDatas = dataList
        case .failure(let failure):
            alertDelegate?.presentErrorAlert(
                title: "불러오기 실패",
                message: failure.localizedDescription
            )
        }
    }
}
