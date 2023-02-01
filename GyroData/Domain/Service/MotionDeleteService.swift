//
//  MotionDeleteService.swift
//  GyroData
//
//  Created by Ayaan, Wonbi on 2023/01/31.
//

struct MotionDeleteService<T: CoreDataRepository,
                           U: FileManagerRepository>: MotionDeletable where T.Domain == Motion,
                                                                            T.Entity == MotionMO,
                                                                            U.Domain == Motion,
                                                                            U.Entity == MotionDTO {
    let coreDataRepository: T
    let fileManagerRepository: U
    
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
