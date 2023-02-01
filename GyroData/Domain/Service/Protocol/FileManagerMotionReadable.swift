//
//  FileManagerMotionReadable.swift
//  GyroData
//
//  Created by Ayaan, Wonbi on 2023/01/31.
//

protocol FileManagerMotionReadable {
    associatedtype T: FileManagerRepository
    associatedtype Domain: Identifiable
    
    var repository: T { get }
    
    func read(with id: String) -> Domain?
}
