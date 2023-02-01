//
//  FileManagerMotionReadService.swift
//  GyroData
//
//  Created by Ayaan, Wonbi on 2023/01/31.
//

struct FileManagerMotionReadService<T: FileManagerRepository>: FileManagerMotionReadable where T.Domain == Motion, T.Entity == MotionDTO {
    let repository: T
    
    func read(with id: String) -> Motion? {
        do {
            return try repository.read(with: id).asDomain()
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
