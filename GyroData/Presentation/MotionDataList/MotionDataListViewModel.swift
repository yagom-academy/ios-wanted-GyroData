//
//  MotionDataViewModel.swift
//  GyroData
//
//  Created by 천수현 on 2022/12/27.
//
import Foundation

final class MotionDataListViewModel {
    var records = [MotionRecord]()
    private let fetchMotionDataListUseCase = FetchMotionDataListUseCase()
    private let deleteMotionDataListUseCase = DeleteMotionDataUseCase()
    private var pageToLoad = 0
    var hasNextPage = true
    var reloadData: (() -> Void)?
    var isFetching = false

    func viewWillAppear() {
        initializeViewModel()
        fetchMotionDataList(page: pageToLoad)
    }

    func deleteCellSwipeActionDone(indexPath: IndexPath, completion: @escaping () -> Void) {
        let recordToDelete = records[indexPath.row]
        deleteMotionData(id: recordToDelete.id) { [weak self] in
            self?.records.remove(at: indexPath.row)
            completion()
        }
    }

    func fetchNextPage(completion: @escaping ([IndexPath]) -> Void) {
        if !isFetching && hasNextPage {
            isFetching = true
            fetchMotionDataList(page: pageToLoad) { [weak self] fetchedCount in
                guard let self = self, fetchedCount > 0 else { return }
                completion((self.records.count - fetchedCount ..< self.records.endIndex - 1).map {
                    return IndexPath(row: $0, section: 0)
                })
            }
        }
    }

    private func initializeViewModel() {
        hasNextPage = true
        pageToLoad = 0
        records.removeAll()
    }

    private func fetchMotionDataList(page: Int, completion: ((Int) -> Void)? = nil) {
        isFetching = true
        fetchMotionDataListUseCase.execute(page: page) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.records += response.records
                self.pageToLoad = response.currentPage + 1
                self.hasNextPage = response.hasNextPage
                self.isFetching = false
                self.reloadData?()
                completion?(response.records.count)
            case .failure(let error):
                print(error)
            }
        }
    }

    private func deleteMotionData(id: UUID, completion: @escaping () -> Void) {
        deleteMotionDataListUseCase.execute(id: id) { result in
            switch result {
            case .success:
                completion()
            case .failure(let error):
                print(error)
            }
        }
    }
}
