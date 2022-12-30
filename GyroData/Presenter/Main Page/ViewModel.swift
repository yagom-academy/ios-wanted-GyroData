//
//  ViewModel.swift
//  GyroData
//
//  Created by TORI on 2022/12/27.
//

import Foundation

final class ViewModel {
    
    let useCase = UseCase()
    
    var gyroList = [MeasureItem]()
    var errorMessage = ""
    
    func onCreate(item: MeasureItem) {
        
    }
    
    func onRead() {
        useCase.readItem { [weak self] result in
            switch result {
            case let .success(items):
                self?.gyroList = items
            case let .failure(error):
                self?.errorMessage = error.localizedDescription
            }
        }
    }
    
    func onDelete() {}
}
