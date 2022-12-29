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
    var reloadData: (() -> Void)?

    func viewDidLoad() {
        fetchMotionDataList(page: pageToLoad)
    }

    func deleteCellSwipeActionDone(indexPath: IndexPath, completion: @escaping () -> Void) {
        let recordToDelete = records[indexPath.row]
        deleteMotionData(id: recordToDelete.id) {
            self.records.remove(at: indexPath.row)
            completion()
        }
    }

    private func fetchMotionDataList(page: Int) {
        fetchMotionDataListUseCase.execute(page: page) { result in
            switch result {
            case .success(let records):
                self.records = records
                self.reloadData?()
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
