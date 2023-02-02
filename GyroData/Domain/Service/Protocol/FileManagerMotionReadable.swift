//
//  FileManagerMotionReadable.swift
//  GyroData
//
//  Created by Ayaan, Wonbi on 2023/01/31.
//

protocol FileManagerMotionReadable {
    var repository: FileManagerRepository { get }
    
    func read(with id: String) -> Motion?
}
