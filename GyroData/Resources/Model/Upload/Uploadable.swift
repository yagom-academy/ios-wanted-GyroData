//
//  Uploadable.swift
//  GyroData
//
//  Copyright (c) 2023 Minii All rights reserved.
        
import Foundation

protocol Uploadable {
    func upload(completion: @escaping (Result<Void, UploadError>) -> Void)
    
    func uploadJson(
        dispatchGroup: DispatchGroup,
        fileName: String,
        transition: Transition,
        completion: @escaping (Result<Bool, UploadError>) -> Void
    )
    
    func uploadCoreDataObject(
        dispatchGroup: DispatchGroup,
        metaData: TransitionMetaData,
        completion: @escaping (Result<Bool, UploadError>) -> Void
    )
}

extension Uploadable {
    func uploadJson(
        dispatchGroup: DispatchGroup,
        fileName: String,
        transition: Transition,
        completion: @escaping (Result<Bool, UploadError>) -> Void
    ) {
        dispatchGroup.enter()
        let result = SystemFileManager().saveData(fileName: fileName, value: transition)
        completion(.success(result))
        dispatchGroup.leave()
    }
    
    func uploadCoreDataObject(
        dispatchGroup: DispatchGroup,
        metaData: TransitionMetaData,
        completion: @escaping (Result<Bool, UploadError>) -> Void
    ) {
        dispatchGroup.enter()
        let result = PersistentContainerManager.shared.createNewGyroObject(metaData: metaData)
        completion(.success(result))
        dispatchGroup.leave()
    }
}
