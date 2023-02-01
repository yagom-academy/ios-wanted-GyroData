//
//  CoreDataMotionReadService.swift
//  GyroData
//
//  Created by Ayaan, Wonbi on 2023/01/31.
//

struct CoreDataMotionReadService<T: CoreDataRepository>: CoreDataMotionReadable where T.Entity == MotionMO,
                                                                                      T.Domain == Motion {
    typealias CoreDataRepository = T
    
    let coreDataRepository: CoreDataRepository
    
    func read(from offset: Int) -> [Motion]? {
        do {
            return try coreDataRepository.read(from: offset).compactMap { $0.asDomain() }
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
