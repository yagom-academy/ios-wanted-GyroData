//
//  ThirdInfoViewModel.swift
//  GyroData
//
//  Created by 한경수 on 2022/09/21.
//

import Foundation

class ThirdInfoViewModel {
    // MARK: Input
    var didReceiveViewTypeChanged: (ViewType) -> () = { type in }
    
    // MARK: Output
    var viewTypeChanged: (ViewType) -> () = { type in } {
        didSet {
            viewTypeChanged(viewType)
        }
    }
    
    // MARK: Properties
    var viewType: ViewType {
        didSet {
            viewTypeChanged(viewType)
        }
    }
    
    // MARK: Init
    init(viewType: ViewType) {
        self.viewType = viewType
        bind()
    }
    
    // MARK: Bind
    func bind() {
        didReceiveViewTypeChanged = { [weak self] viewType in
            self?.viewType = viewType
        }
    }
}
