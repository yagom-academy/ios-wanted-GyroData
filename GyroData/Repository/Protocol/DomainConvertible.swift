//
//  DomainConvertible.swift
//  GyroData
//
//  Created by Ayaan, Wonbi on 2023/01/31.
//

protocol DomainConvertible {
    associatedtype Domain
    
    func asDomain() -> Domain?
}
