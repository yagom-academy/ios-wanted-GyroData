//
//  MotionCreatable.swift
//  GyroData
//
//  Created by Ayaan, Wonbi on 2023/01/31.
//

enum CreatingServiceResult<T> {
    case success(T)
    case failure(CreatingError)
    
    enum CreatingError: Error {
        case motionCreatingFailed
        case insufficientDataToCreate
    }
}

protocol MotionCreatable {
    var coreDataRepository: CoreDataRepository { get }
    var fileManagerRepository: FileManagerRepository { get }
    
    func create(
        date: String,
        type: Int,
        time: String,
        data: [MotionDataType],
        completion: @escaping (CreatingServiceResult<Void>) -> Void)
}
