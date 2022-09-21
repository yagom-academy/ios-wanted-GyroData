//
//  FirstListViewModel.swift
//  GyroData
//
//  Created by pablo.jee on 2022/09/20.
//

import Foundation

class FirstListViewModel {
    //input
    var didSelectRow: (Int) -> () = { indexPathRow in }
    var didSelectPlayAction: (Int) -> () = { indexPathRow in }
    
    //output
    var propagateDidSelectRowEvent: (Int) -> () = { indexPathRow in }
    var propagateDidSelectPlayActionEvent: (Int) -> () = { indexPathRow in }
    
    //properties
    init() {
        bind()
    }
    
    private func bind() {
        didSelectRow = { [weak self] indexPathRow in
            guard let self = self else { return }
            self.propagateDidSelectRowEvent(indexPathRow)
        }
        didSelectPlayAction = { [weak self] indexPathRow in
            guard let self = self else { return }
            self.propagateDidSelectPlayActionEvent(indexPathRow)
        }
    }
    
}
