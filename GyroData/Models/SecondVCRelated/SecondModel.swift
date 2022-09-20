//
//  SecondModel.swift
//  GyroData
//
//  Created by pablo.jee on 2022/09/20.
//

import Foundation

class SecondModel {
    
    //output
    var segmentViewModel: SecondSegmentViewModel {
        return privateSecondSegmentViewModel
    }
    
    //input
    
    //properties
    private var repository: RepositoryProtocol
    private var privateSecondSegmentViewModel: SecondSegmentViewModel
    
    init(repository: RepositoryProtocol) {
        self.repository = repository
        self.privateSecondSegmentViewModel = SecondSegmentViewModel()
    }
}
