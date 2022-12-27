//
//  ViewModel.swift
//  GyroData
//
//  Created by TORI on 2022/12/27.
//

import Foundation

final class ViewModel {
    
    let useCase = UseCase()
    
    var gyroList = [GyroItem]()
    
    func onCreate(item: GyroItem) {
        useCase.createItem(item)
    }
    
    func onRead(onComplete: @escaping ([GyroItem]) -> ()) {
        useCase.readItem { [weak self] items in
            self?.gyroList = items
        }
    }
}
