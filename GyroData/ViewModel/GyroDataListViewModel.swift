//
//  GyroDataListViewModel.swift
//  GyroData
//
//  Created by 리지 on 2023/06/13.
//

import Foundation
import Combine

final class GyroDataListViewModel {
    @Published private(set) var gyroData: [GyroEntity] = []
    
    private let measureViewModel: MeasureViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(measureViewModel: MeasureViewModel) {
        self.measureViewModel = measureViewModel
        bind()
    }
    
    func bind() {
        measureViewModel.createSubject
            .sink { [self] data in
                gyroData.append(data)
            }
            .store(in: &cancellables)
    }
    
    func readAll() {
        guard let data = CoreDataManager.shared.readTenPiecesOfData() else { return }
        gyroData.append(contentsOf: data)
    }
    
    func read(at indexPath: IndexPath) -> GyroEntity {
        gyroData[indexPath.row]
    }
    
    func delete(by id: UUID) {
        gyroData.removeAll { $0.id == id }
        CoreDataManager.shared.delete(by: id)
        deleteFile(withId: id)
    }
    
    private func deleteFile(withId id: UUID) {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileName = "\(id).json"
        let fileURL = documentDirectory.appendingPathComponent("GyroData폴더").appendingPathComponent(fileName)
        
        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch {
            print(error.localizedDescription)
        }
    }
}
