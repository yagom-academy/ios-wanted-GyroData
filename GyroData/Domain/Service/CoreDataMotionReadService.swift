//
//  CoreDataMotionReadService.swift
//  GyroData
//
//  Created by Ayaan, Wonbi on 2023/01/31.
//

struct CoreDataMotionReadService: CoreDataMotionReadable {
    let coreDataRepository: CoreDataRepository
    
    func read(from offset: Int) -> [Motion]? {
        do {
            return try coreDataRepository.read(from: offset).compactMap { $0.asDomain() }
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func count() -> Int? {
        do {
            let count = try coreDataRepository.count()
            return count
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
