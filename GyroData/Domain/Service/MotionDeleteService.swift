//
//  MotionDeleteService.swift
//  GyroData
//
//  Created by Ayaan, Wonbi on 2023/01/31.
//

struct MotionDeleteService: MotionDeletable {
    let coreDataRepository: CoreDataRepository
    let fileManagerRepository: FileManagerRepository
    
    func delete(_ id: String) -> Bool {
        do {
            try coreDataRepository.delete(with: id)
            try fileManagerRepository.delete(with: id)
        } catch {
            print(error.localizedDescription)
            return false
        }
        return true
    }
}
