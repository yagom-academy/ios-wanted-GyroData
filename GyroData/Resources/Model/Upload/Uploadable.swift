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
        completion: @escaping (Result<Void, FileWriteError>) -> Void
    )
    
    func uploadCoreDataObject(
        dispatchGroup: DispatchGroup,
        metaData: TransitionMetaData,
        completion: @escaping (Result<Void, FileWriteError>) -> Void
    )
}

extension Uploadable {
    func uploadJson(
        dispatchGroup: DispatchGroup,
        fileName: String,
        transition: Transition,
        completion: @escaping (Result<Void, FileWriteError>) -> Void
    ) {
        dispatchGroup.enter()
        SystemFileManager().saveData(fileName: fileName, value: transition) { result in
            completion(result)
            dispatchGroup.leave()
        }
    }
    
    func uploadCoreDataObject(
        dispatchGroup: DispatchGroup,
        metaData: TransitionMetaData,
        completion: @escaping (Result<Void, FileWriteError>) -> Void
    ) {
        dispatchGroup.enter()
        PersistentContainerManager.shared.createNewGyroObject(metaData: metaData) { result in
            completion(result)
            dispatchGroup.leave()
        }
    }
}
