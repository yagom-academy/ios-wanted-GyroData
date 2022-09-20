//
//  FirstListViewModel.swift
//  GyroData
//
//  Created by pablo.jee on 2022/09/20.
//

import Foundation
//testteesttest
class FirstListViewModel {
    //input
    var didSelectRow: (Int) -> () = { indexPathRow in }
    
    //output
    var propergateDidSelectRowEvent: (Int) -> () = { indexPathRow in }
    
    //properties
    init() {
        bind()
    }
    
    private func bind() {
        didSelectRow = { [weak self] indexPathRow in
            guard let self = self else { return }
            self.propergateDidSelectRowEvent(indexPathRow)
        }
    }
    
}
